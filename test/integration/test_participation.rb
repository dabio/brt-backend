# coding:utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#
#
#
#require 'helper'
#
#class TestParticipation < TestHelper
#
#  # tests if non authenticated users are allowed to post and/or delete
#  # participations
#  def test_participations_404
#    event = Event.first(id: 10)
#    post event.participation_editlink
#    assert_equal 404, last_response.status
#    delete event.participation_editlink
#    assert_equal 404, last_response.status
#  end
#
#  # tests the ability to create new participations for e certain events.
#  def test_create_participations
#    login
#    event = Event.first(id: 10)
#    post event.participation_editlink
#    assert last_response.ok?
#    logout
#
#    person = Person.first(slug: 'dummy-user')
#    get person.permalink
#    assert last_response.body.include?(event.title)
#  end
#
#  # tests deleting a participation. we use the participation created in the
#  # method above
#  def test_delete_participation
#    login
#    event = Event.first(id: 10)
#    delete event.participation_editlink
#    assert last_response.ok?
#    logout
#
#    person = Person.first(slug: 'dummy-user')
#    get person.permalink
#    assert !last_response.body.include?(event.title)
#  end
#
#end
