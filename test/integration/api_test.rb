require File.expand_path('../../helper', __FILE__)

context 'App' do

  setup do; end


  test '/api/persons' do
    get '/api/person'
    assert_equal 404, last_response.status

    post '/api/persons'
    assert_equal 404, last_response.status
  end

  test '/api/events' do
    get '/api/events'
    assert_equal 404, last_response.status

    post '/api/events'
    assert_equal 404, last_response.status
  end


  test '/api/news' do
    get '/api/news'
    assert_equal 404, last_response.status

    post '/api/news'
    assert_equal 404, last_response.status
  end


  test '/api/visits' do
    get '/api/visits'
    assert_equal 404, last_response.status

    put '/apu/visits'
    assert_equal 404, last_response.status
  end


  test '/api/emails' do
    get '/api/emails'
    assert_equal 404, last_response.status

    delete '/api/emails/1'
    assert_equal 404, last_response.status
  end

end
