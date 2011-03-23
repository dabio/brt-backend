# coding:utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


ENV['RACK_ENV'] = "test"


require 'rack/test'
require 'minitest/autorun'

require_relative '../site'


module TestHelper
  include Rack::Test::Methods
  include Sinatra::MainHelper
  include Sinatra::PersonHelper

  def app
    BerlinRacingTeam
  end

  def setup; end

  def teardown; end

end
