# coding:utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


require_relative 'test_helper'

class LoginTest < MiniTest::Unit::TestCase

  include TestHelper

  def test_login
    login
    assert_match "Hallo Dummy, du bist angemeldet", page.body
  end

end

