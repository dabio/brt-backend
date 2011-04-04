# coding:utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


require_relative 'test_helper'

class SiteTest < MiniTest::Unit::TestCase

  include TestHelper

  def test_hello_world
    visit '/'
    assert_equal 200, page.status_code

    visit '/rennen'
    assert_equal 200, page.status_code

    visit '/team'
    assert_equal 200, page.status_code

    visit '/kontakt'
    assert_equal 200, page.status_code

    visit '/team/nina-buhne'
    assert_equal 200, page.status_code

    visit '/team/danilo-braband'
    assert_equal 200, page.status_code
    assert_match'11 Rennen mit 758 km und 3 Top10 Platzierungen', page.body

    # sites are only visible for logged in users
    visit '/diskussionen'
    assert_equal 404, page.status_code

    visit '/diskussionen/6'
    assert_equal 404, page.status_code

    visit '/team/danilo-braband/edit'
    assert_equal 404, page.status_code
  end


  def test_login
    login
    assert_match 'Hallo Dummy, du bist angemeldet', page.body
    assert_match 'Diskussionen', page.body
    logout
  end


  def test_person_edit
    login
    # change email
    visit '/team/dummy-user/edit'
    fill_in 'E-Mail', with: 'dummy@email.com'
    click_button 'Speichern'
    visit '/team/dummy-user/edit'
    assert_match 'dummy@email.com', page.body

    # invalid email
    fill_in 'E-Mail', with: 'invalidemail.com'
    click_button 'Speichern'
    assert_match 'invalid format', page.body

    # confirm email
    fill_in 'Passwort', with: 1234
    fill_in 'Passwort wiederholen', with: 4321
    click_button 'Speichern'
    assert_match 'does not match the confirmation', page.body

    logout
  end

end
