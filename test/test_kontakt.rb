# coding:utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


require 'helper'

class TestKontakt < Test::Unit::TestCase
  include Rack::Test::Methods
  include Helpers

  def app
    BerlinRacingTeam
  end

  def login
    post '/login', {email: 'dummy@user.com', password: 'test123'}
  end

  def logout
    get '/logout'
  end

  def test_kontakt
    get '/kontakt'
    assert last_response.ok?
    assert last_response.body.include?('Danilo Braband')
  end

  def test_kontakt_submit_with_spam_email
    post '/kontakt', {email: 'this@email.spam'}
    assert_equal 404, last_response.status
  end
end