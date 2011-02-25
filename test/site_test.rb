require 'cuba/test'
require File.expand_path('../site', File.dirname(__FILE__))

prepare do
  # true for all request
  def has_admin?
    true
  end
end

setup do
  ENV['RACK_ENV'] = 'test'
end

scope do
  test 'Home' do
    visit '/'
    # header
    assert has_content?('Berlin Racing Team')
    # nav
    assert has_content?('Home')
    #assert has_content?('Team')
    #assert has_content?('Sponsoren')
    assert has_content?('Kontakt')
    # news
    assert has_content?('Nachrichten')
    # footer
    assert has_content?('Facebook')
  end

  test 'Kontakt' do
    visit '/kontakt'
    # title
    assert has_content?('Kontakt')
    # Adresse
    assert has_content?('Danilo Braband')
  end

  test 'Team' do
    # check the team site
    visit '/team'
    assert has_content?('Oliver Schulz')
    assert has_content?('Lars Hiekmann')
    assert has_content?('Jens Heller')
    assert has_content?('Danilo Braband')

    # check the edit mask
    visit '/team/new'
    assert has_selector?('form')
    assert has_content?('Neuer Fahrer')
    assert has_button?('Speichern')

    # check for driver detail view
    visit '/team/oliver-schulz'
    assert has_content?('found')

    # check for 404s
    visit '/team/lala'
    assert has_content?('Seite nicht gefunden')
    visit '/team/steve-jobs'
    assert has_content?('Seite nicht gefunden')
    visit '/team/steve-jobs/edit'
    assert has_content?('Seite nicht gefunden')
  end
end

