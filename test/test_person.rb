# coding:utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


require 'helper'

class TestPerson < Test::Unit::TestCase
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

  def setup
    login
    @dummy = Person.first(slug: 'dummy-user')
  end

  def teardown
    logout
  end

  def test_person_change_email
    get @dummy.editlink
    assert last_response.ok?
    assert last_response.body.include?(@dummy.email)

    put @dummy.editlink, {'person[email]' => 'dummy@user.de'}
    assert last_response.headers['Location'].include?(@dummy.editlink)

    get @dummy.editlink
    assert !last_response.body.include?(@dummy.email)
    assert last_response.body.include?('dummy@user.de')

    # change back to old email address
    put @dummy.editlink, {'person[email]' => @dummy.email}
  end

  def test_person_change_password_wrong_confirmation
    put @dummy.editlink, {'person[email]' => @dummy.email,
      'person[password]' => 'test1', 'person[password_confirmation]' => 'test2'}
    assert last_response.body.include?('Password does not match the confirmation')
  end

  def test_person_change_password
    put @dummy.editlink, {'person[email]' => @dummy.email,
      'person[password]' => 'test', 'person[password_confirmation]' => 'test'}
    assert last_response.headers['Location'].include?(@dummy.editlink)

    put @dummy.editlink, {'person[email]' => @dummy.email,
      'person[password]' => 'test123',
      'person[password_confirmation]' => 'test123'}
    assert last_response.headers['Location'].include?(@dummy.editlink)
  end

  def test_person_visit_logged_in
    put '/visit'
    assert_equal 200, last_response.status
  end

end
