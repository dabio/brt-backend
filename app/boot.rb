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

# Library
Dir['./lib/*.rb'].each { |f| require f }

# Helpers, Models, Routes, Views
Dir['./app/**/*.rb'].each { |f| require f }

## Finalize Datamapper Models
DataMapper.finalize

module Brt

  class Main < Sinatra::Base
    use Rack::ForceDomain, ENV['DOMAIN']
    use Rack::Session::Cookie
    use Rack::Protection

    register Sinatra::Flash
    register Sinatra::R18n
    register Mustache::Sinatra

    helpers Brt::Helpers

    set :root, ROOT_DIR
    set :public_folder, "#{ROOT_DIR}/public"

    set :default_locale, 'de'
    set :method_override, true

    # redirect all requests ending with a slash to their corresponding requests
    # without the slash
    get %r{(.+)/$} do |r|
      redirect to(r)
    end

    # store the flash-session into the global flash variable
    before do
      @flash = session.delete 'flash'
    end

  end

  class Admin < Main
    set :mustache, {
      namespace: Brt,
      layout: Brt::Views::AdminLayout,
      templates: "#{ROOT_DIR}/admin/templates",
      views: "#{ROOT_DIR}/admin/views"
    }
  end

  class Frontend < Main
    set :mustache, {
      namespace: Brt,
      templates: "#{ROOT_DIR}/frontend/templates",
      views: "#{ROOT_DIR}/frontend/views"
    }
  end

end
