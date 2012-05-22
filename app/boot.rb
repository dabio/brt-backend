$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined? RACK_ENV

require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

DataMapper::Logger.new($stdout, :debug) if RACK_ENV == 'development'
DataMapper.setup(
  :default, ENV['HEROKU_POSTGRESQL_GRAY_URL'] || 'postgres://dan@localhost/brt')

R18n.set('de')

# Library
require_relative '../lib/dm_bcrypt'
require_relative '../lib/dm_uri'
require_relative '../lib/hash'

# Models
require_relative 'models/comment'
require_relative 'models/debate'
require_relative 'models/email'
require_relative 'models/event'
require_relative 'models/news'
require_relative 'models/participation'
require_relative 'models/person'
require_relative 'models/report'
require_relative 'models/visit'
DataMapper.finalize

# Helper
require_relative 'helpers'

# Non-autoloaded views
require_relative 'views/layout'

module Brt

  class Main < Sinatra::Base
    use Rack::ForceDomain, ENV['DOMAIN']
    use Rack::Session::Cookie
    use Rack::Protection
  end

  class App < Main
    register Sinatra::Flash
    register Mustache::Sinatra
    helpers Brt::Helpers

    dir = File.dirname(File.expand_path(__FILE__))

    set :default_locale, 'de'
    set :public_folder, "#{dir}/frontend/public"
    set :method_override, true
    set :mustache, {
      namespace: Brt,
      templates: "#{dir}/templates",
      views: "#{dir}/views"
    }
  end

end

# App
require 'app'
