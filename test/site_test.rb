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
    get '/'
    assert_equal 200, last_response.status
  end

end
