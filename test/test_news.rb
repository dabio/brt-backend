# coding:utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


require 'helper'

class TestNews < TestHelper

  def test_get_news
    get '/news'
    assert last_response.ok?

    news = News.all(:date.lte => today, order: [:date.desc, :updated_at.desc],
                    limit: 5)
    news.each do |item|
      assert last_response.body.include?(item.permalink)
    end
  end

  def test_post_news
    post '/news'
    assert_equal 404, last_response.status
  end

  def test_get_news_detail
    news = News.first id:1
    get news.permalink
    assert last_response.ok?
  end

  # News manipulation without authorization
  # PUT
  def test_put_news_detail
    news = News.first id:1
    put news.permalink
    assert_equal 404, last_response.status
  end

  # DELETE
  def test_delete_news_detail
    news = News.first id:1
    delete news.permalink
    assert_equal 404, last_response.status
  end

  # News manipulation with authorization

end

