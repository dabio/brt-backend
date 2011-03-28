# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class BerlinRacingTeam

  register Sinatra::Flash
  register Sinatra::R18n

  use Rack::ForceDomain, ENV['DOMAIN']
  use Rack::Session::Cookie

  set :root, File.dirname(__FILE__)
  set :cdn, '//berlinracingteam.commondatastorage.googleapis.com'

  helpers Sinatra::BerlinRacingTeamHelper

  helpers do
    [:development, :production, :test].each do |environment|
      define_method "#{environment.to_s}?" do
        return settings.environment == environment.to_sym
      end
    end
  end

  configure :development do
    require 'new_relic/rack_app'
    use NewRelic::Rack::DeveloperMode
  end

end
