# coding:utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


ENV['RACK_ENV'] = "test"

require 'capybara/dsl'
require 'minitest/autorun'
require 'rack/test'

require_relative '../site'


module TestHelper
  include Capybara
  include Rack::Test::Methods
  include Sinatra::MainHelper
  include Sinatra::PersonHelper

  def app
    BerlinRacingTeam
  end

  def setup; end

  def teardown; end

  Capybara.app = BerlinRacingTeam

end
