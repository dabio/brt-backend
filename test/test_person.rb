# coding:utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


require 'helper'

class TestPerson < TestHelper

  def test_person_detail
    person = Person.first(slug: 'danilo-braband')

    get person.permalink
    assert last_response.ok?

    person.participations.each do |p|
      assert last_response.body.include?(p.event.title.sub(/\s.+/, ''))
    end
    assert last_response.body.include?("Rennen: #{person.participations.length}")
    assert last_response.body.include?(encrypt_email(person.email))
  end

  def test_person_edit_404
    person = Person.first(slug: 'dummy-user')
    get person.editlink
    assert_equal 404, last_response.status
  end

  def test_person_change_email
    login
    dummy = Person.first(slug: 'dummy-user')
    get dummy.editlink
    assert last_response.ok?
    assert last_response.body.include?(dummy.email)

    put dummy.editlink, {'person[email]' => 'dummy@user.de'}
    assert last_response.headers['Location'].include?(dummy.editlink)

    get dummy.editlink
    assert !last_response.body.include?(dummy.email)
    assert last_response.body.include?('dummy@user.de')

    # change back to old email address
    put dummy.editlink, {'person[email]' => dummy.email}
    logout
  end

  def test_person_change_password_wrong_confirmation
    login
    dummy = Person.first(slug: 'dummy-user')
    put dummy.editlink, {'person[email]' => dummy.email,
      'person[password]' => 'test1', 'person[password_confirmation]' => 'test2'}
    assert last_response.body.include?('Password does not match the confirmation')
    logout
  end

  def test_person_change_password
    login
    dummy = Person.first(slug: 'dummy-user')
    put dummy.editlink, {'person[email]' => dummy.email,
      'person[password]' => 'test', 'person[password_confirmation]' => 'test'}
    assert last_response.headers['Location'].include?(dummy.editlink)

    put dummy.editlink, {'person[email]' => dummy.email,
      'person[password]' => 'test123',
      'person[password_confirmation]' => 'test123'}
    assert last_response.headers['Location'].include?(dummy.editlink)
    logout
  end

  def test_person_visit_404
    put '/visit'
    assert_equal 404, last_response.status
  end

  def test_person_visit_logged_in
    login
    put '/visit'
    assert_equal 200, last_response.status
    logout
  end

end

