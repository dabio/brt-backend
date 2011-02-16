require 'cuba/test'
require File.expand_path('../site', File.dirname(__FILE__))

prepare do

end

setup do

end

scope do
  test 'Home' do
    visit '/'

    assert has_content?('Berlin Racing Team')
  end
end

