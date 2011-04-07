# coding:utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


require 'helper'

class TestSite < Test::Unit::TestCase
  include Rack::Test::Methods
  include Helpers

  def app
    BerlinRacingTeam
  end

  def test_main_css
    get '/css/styles.css'
    assert last_response.ok?
    assert last_response.body.include?('background')
  end

  def test_head_index
    head '/'
    assert last_response.ok?
    assert !last_response.body.include?('DOCTYPE html')
  end

  def test_front_page_essentials
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('DOCTYPE html')
    assert last_response.body.include?('Neuigkeiten rund um das Berlin Racing Team')
  end

  def test_team_site_essentials
    get '/team'
    assert last_response.ok?
    Person.all.each do |person|
      assert last_response.body.include?(person.medium_url)
    end
  end

  def test_person_detail
    person = Person.first(slug: 'danilo-braband')

    get person.permalink
    assert last_response.ok?

    person.participations.each do |p|
      assert last_response.body.include?(p.event.title)
    end
    assert last_response.body.include?("Rennen: #{person.participations.length}")
    assert last_response.body.include?(encrypt_email(person.email))
  end

  def test_person_edit_404
    person = Person.first(slug: 'danilo-braband')
    get person.editlink
    assert_equal 404, last_response.status
  end

  def test_404
    get '/fake/path'
    assert_equal 404, last_response.status
    assert last_response.body.include?('Seite nicht gefunden werden')
  end
end

