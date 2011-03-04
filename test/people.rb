require File.expand_path('helper', File.dirname(__FILE__))

scope do
  test 'View Team' do
    visit '/team'
    # header
    assert has_content?('Berlin Racing Team')

    assert has_content?("Danilo Braband")
    assert has_content?("Lars Hiekmann")
    assert has_content?("Team")

    # footer
    assert has_content?('Facebook')
  end
end


