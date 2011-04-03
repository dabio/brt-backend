# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


require 'bundler'
Bundler.require

RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined? RACK_ENV
ROOT_DIR = File.dirname(__FILE__) unless defined? ROOT_DIR

# Helper method for file references.
#
# @params args [Array] Path components relative to ROOT_DIR.
# @example Referencing a file in config called settings.yml:
#   root_path('config', 'settings.xml')
def root_path(*args)
  File.join(ROOT_DIR, *args)
end

# Sinatra::Base. This way, we're not polluting the global namespace with your
# methods and routes and such.
class BerlinRacingTeam < Sinatra::Base; end

class BerlinRacingTeam
  set :method_override, true
  set :root, root_path

  set :cdn, '//berlinracingteam.commondatastorage.googleapis.com'

  register Sinatra::Flash
  register Sinatra::R18n

  use Rack::ForceDomain, ENV['DOMAIN']
  use Rack::Session::Cookie
  # We're using rack-timeout to ensure that our dynos don't get starved by
  # renegade processes.
  use Rack::Timeout
  Rack::Timeout.timeout = 10

  configure :development, :test do
    begin
      require 'ruby-debug'
    rescue LoadError
    end
  end

  helpers do
    [:development, :production, :test].each do |environment|
      define_method "#{environment.to_s}?" do
        return settings.environment == environment.to_sym
      end
    end
  end

end

DataMapper::Logger.new($stdout, :debug) if RACK_ENV == 'development'
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db/local.db?encoding=utf8')

# controllers
Dir[root_path('controllers/*.rb')].each do |file|
  require(file)
end

# models
Dir[root_path('models/*.rb')].each do |file|
  require(file)
end

# helpers
require(root_path('helpers.rb'))

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

