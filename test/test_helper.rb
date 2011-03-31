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

require_relative '../init'


module TestHelper
  include Capybara
  include Rack::Test::Methods

  def app
    BerlinRacingTeam
  end

  def setup
    Person.create(first_name: 'Dummy', last_name: 'User', email: 'dummy@user.com',
                  password: 'test123', password_confirmation: 'test123')
  end

  def teardown
    Person.all(first_name: 'Dummy', last_name: 'User').destroy!
  end

  def login
    visit '/login'

    fill_in 'email', :with => 'dummy@user.com'
    fill_in 'password', :with => 'test123'
    click_button 'Anmelden'
  end

  def logout
    visit '/'
    click_link 'Abmelden'
  end

  Capybara.app = BerlinRacingTeam

end
