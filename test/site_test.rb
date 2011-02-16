require 'cuba/test'
require File.expand_path('../site', File.dirname(__FILE__))

prepare do

end

setup do

end

scope do
  test 'Home' do
    visit '/'

    # header
    assert has_content?('Berlin Racing Team')

    # nav
    assert has_content?('Home')
    assert has_content?('Team')
    assert has_content?('Sponsoren')
    assert has_content?('Kontakt')

    # news
    assert has_content?('Nachrichten')
  end
end

