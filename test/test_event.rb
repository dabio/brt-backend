# coding:utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


require 'helper'

class TestEvent < Test::Unit::TestCase
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
    @event = Event.first(id: 10)
  end

  def test_event_view_404
    get @event.permalink
    assert_equal 404, last_response.status
  end

  def test_event_edit_404
    get @event.editlink
    assert_equal 404, last_response.status
    put @event.editlink
    assert_equal 404, last_response.status
  end

  def test_event_edit
    login
    get @event.editlink
    assert last_response.ok?
    assert last_response.body.include?(@event.title)
    logout
  end

  def test_event_edit_title
    login
    put @event.editlink, {'event[title]' => 'testtitel'}
    assert last_response.headers['Location'].include?(@event.editlink)
    logout
  end

  def test_event_edit_title_to_none
    login
    put @event.editlink, {'event[title]' => ''}
    assert last_response.body.include?('Title must not be blank')
    logout
  end

  def test_new_event_404
    get '/rennen/new'
    assert_equal 404, last_response.status
    post '/rennen/new'
    assert_equal 404, last_response.status
  end

  def test_new_event
    login

    get '/rennen/new'
    assert last_response.ok?

    post '/rennen/new', {'event[date]' => today, 'event[title]' => 'Test Event Title',
      'event[url]' => 'http://berlinracingteam.de/', 'event[distance]' => 100}
    new_event = Event.first(date: today, slug: 'test-event-title')

    get new_event.editlink
    assert last_response.ok?
    assert last_response.body.include?('Test Event Title')

    logout
  end

  def test_new_event_missing_fields
    login
    post '/rennen/new', {'event[date]' => today, 'event[title]' => 'New Title'}
    assert last_response.ok?
    assert last_response.body.include?('Korrigiere bitte folgende Angabe')
    logout
  end

end

