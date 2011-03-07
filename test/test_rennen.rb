require File.expand_path('helper', File.dirname(__FILE__))

scope do
  test 'View event calendar' do
    visit '/rennen'
    # header
    assert has_content? 'Berlin Racing Team'

    assert has_content? "April"
    assert has_content? "Mai"
    assert has_content? "Juni"
    assert has_content? "Einzelzeitfahren"
    # footer
    assert has_content? 'Facebook'
  end
end



