$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined? RACK_ENV

require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

# PostgreSQL
DataMapper::Logger.new($stdout, :debug) if RACK_ENV == 'development'
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://dan@localhost/brt')

# Library
require_relative '../lib/dm_scrypt'
require_relative '../lib/dm_uri'
require_relative '../lib/hash'

# Models
require 'models/comment'
require 'models/debate'
require 'models/email'
require 'models/event'
require 'models/news'
require 'models/participation'
require 'models/person'
require 'models/report'
require 'models/visit'
DataMapper.finalize

# Helper
require 'helpers'

# Non-autoloaded views
require 'frontend/views/layout'
require 'admin/views/layout'


DIR = File.dirname(File.expand_path(__FILE__))

module Brt

  class Main < Sinatra::Base
    use Rack::ForceDomain, ENV['DOMAIN']
    use Rack::Session::Cookie
    use Rack::Protection

    register Sinatra::Flash
    register Sinatra::R18n
    register Mustache::Sinatra

    helpers Brt::Helpers

    set :root, DIR
    set :public_folder, "#{DIR}/public"

    set :default_locale, 'de'
    set :method_override, true

    # redirect all requests ending with a slash to their corresponding requests
    # without the slash
    get %r{(.+)/$} do |r|
      redirect to(r)
    end

  end

  class Admin < Main
    set :mustache, {
      namespace: Brt,
      templates: "#{DIR}/admin/templates",
      views: "#{DIR}/admin/views"
    }
  end

  class Frontend < Main
    set :mustache, {
      namespace: Brt,
      templates: "#{DIR}/frontend/templates",
      views: "#{DIR}/frontend/views"
    }
  end

end

# Admin
require 'admin'
# Api
#require 'api'
# Frontend
require 'frontend'
