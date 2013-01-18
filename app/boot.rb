# encoding: utf-8

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined? RACK_ENV
ROOT_DIR = File.dirname(File.expand_path(__FILE__))

require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

# PostgreSQL
DataMapper::Logger.new($stdout, :debug) if RACK_ENV == 'development'
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://dan@localhost/brt')
DataMapper.repository(:default).adapter.resource_naming_convention = DataMapper::NamingConventions::Resource::UnderscoredAndPluralizedWithoutModule

Dir[
  './lib/*.rb',
  './app/models/*.rb',
].each do |f|
  require f
end

# Finalize Datamapper Models
DataMapper.finalize

module Brt

  class Main < Sinatra::Base
    use Rack::ForceDomain, ENV['DOMAIN']
    use Rack::Session::Cookie, secret: 'blah'
    use Rack::Protection

    register Sinatra::Flash
    register Sinatra::R18n

    configure do
      enable :method_override
      # enable :inline_templates

      set :root, ROOT_DIR
      set :public_folder, "#{ROOT_DIR}/../public"
      set :default_locale, 'de'
    end

    configure :production do
      disable :logging
    end

    configure :development do
      enable :logging
      enable :show_exceptions
    end

    configure :test do
      enable :raise_errors
      disable :logging
      disable :reload_templates
    end

    # store the flash-session into the global flash variable
    before do
      @flash = session.delete 'flash'
    end

    error do
      'Error'
    end

  end

end

Dir[
  './app/admin.rb',
  './app/admin_*.rb'
].each do |f|
  require f
end
