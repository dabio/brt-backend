# coding:utf-8
#
#   this is berlinracingteam.de, a cuba application
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

    # site is only visible for logged in users
    visit '/diskussionen'
    assert_equal 404, page.status_code
  end


  def test_login
    login
    assert_match 'Hallo Dummy, du bist angemeldet', page.body
    assert_match 'Diskussionen', page.body
    logout
  end


  def test_person_edit
    visit '/team/dummy-user/edit'
    assert_equal 404, page.status_code

    #login
  end

end
