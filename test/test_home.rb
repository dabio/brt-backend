require File.expand_path('helper', File.dirname(__FILE__))

scope do
  test 'View homepage' do
    visit '/'
    # header
    assert has_content?('Berlin Racing Team')
    # nav
    assert has_content?('Home')
    assert has_content?('Team')
    #assert has_content?('Sponsoren')
    assert has_content?('Kontakt')
    # news
    assert has_content?('Nachrichten')
    # footer
    assert has_content?('Facebook')
  end
end

