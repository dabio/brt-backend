# coding:utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


require 'helper'

class TestDebate < TestHelper

  def test_debates_404
    get '/diskussionen'
    assert_equal 404, last_response.status
  end

  def test_debates
    login
    get '/diskussionen'
    assert last_response.ok?

    Debate.all.each do |debate|
      assert last_response.body.include?(debate.permalink)
    end

    logout
  end

  def test_debate_new_404
    get '/diskussionen/new'
    assert_equal 404, last_response.status

    post '/diskussionen/new'
    assert_equal 404, last_response.status
  end

  def test_debate_new
    login
    get '/diskussionen/new'
    assert last_response.ok?

    post '/diskussionen/new', {'debate[title]' => 'test titel',
      'comment[text]' => 'test text for our comment'}
    # get last response and check if it is in our redirect url
    debate = Debate.first(order: [:created_at.desc])
    assert last_response.headers['Location'].include?(debate.permalink)
    get debate.permalink
    assert last_response.body.include?(debate.title)
    logout
  end

  def test_debate_new_wrong_input
    login
    post '/diskussionen/new'
    assert last_response.body.include?('Korrigiere bitte folgende Angabe')
    post '/diskussionen/new', {'debate[title]' => 'test titel'}
    assert last_response.body.include?('Korrigiere bitte folgende Angabe')
    logout
  end

  def test_debate_404
    Debate.all.each do |debate|
      get debate.permalink
      assert_equal 404, last_response.status
    end
  end

  def test_debate
    login
    Debate.all.each do |debate|
      get debate.permalink
      assert last_response.body.include?(" › #{debate.title.sub(/\s.+/, '')}")
    end
    logout
  end

  def test_debate_comment_404
    post '/comments/new'
    assert_equal 404, last_response.status
  end

  def test_debate_comment
    login
    debate = Debate.first(order: [:created_at.desc])
    post '/comments/new', {'type' => 'Debate', 'type_id' => debate.id,
      'text' => 'Testcomment'}
    assert last_response.headers['Location'].include?("#{debate.permalink}#comment_")
    logout
  end

  def test_debate_comment_missing_text
    login
    debate = Debate.first(order: [:created_at.desc])
    post '/comments/new', {'type' => 'Debate', 'type_id' => debate.id}
    assert last_response.headers['Location'].include?(debate.permalink)
    logout
  end

end

