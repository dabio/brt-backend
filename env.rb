# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined? RACK_ENV
ROOT_DIR = File.dirname(__FILE__) unless defined? ROOT_DIR

require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

# Helper method for file references.
#
# @params args [Array] Path components relative to ROOT_DIR.
# @example Referencing a file in config called settings.yml:
#   root_path('config', 'settings.xml')
def root_path(*args)
  File.join(ROOT_DIR, *args)
end

# lib
Dir[root_path('lib/*.rb')].each do |file|
  require(file)
end

# models
Dir[root_path('models/*.rb')].each do |file|
  require(file)
end


# Sinatra::Base. This way, we're not polluting the global namespace with your
# methods and routes and such.
class App < Sinatra::Base; end

class App

  set :app_file, __FILE__
  set :port, ENV['PORT']
  set :method_override, true
  set :root, root_path
  set :default_locale, 'de'
  set :views, root_path('views')
  set :mustache , {
    views: root_path('views'),
    templates: root_path('templates')
  }

  register Sinatra::Flash
  register Sinatra::R18n
  register Mustache::Sinatra

  use Rack::ForceDomain, ENV['DOMAIN']
  use Rack::Timeout
  use Rack::Session::Cookie
  Rack::Timeout.timeout = 10
  use Rack::Protection

  configure :development, :test do
    begin
      require 'ruby-debug'
    rescue LoadError
    end
  end

  configure :development do
    DataMapper::Logger.new($stdout, :debug) if development?
    DataMapper.setup(:default, 'sqlite3:db/local.db?encoding=utf8')

    register Sinatra::Reloader
  end

  configure :test do
    DataMapper.setup(:default, 'sqlite3:db/test.db?encoding=utf8')
  end

  configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
  end

  DataMapper.finalize

end

# helpers
require(root_path('helpers.rb'))

# views
require(root_path('views/layout.rb'))
Dir[root_path('views/*.rb')].each do |file|
  require(file)
end

require(root_path('app.rb'))


