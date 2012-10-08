require File.expand_path('../../helper', __FILE__)

context 'App' do

  setup do; end


  test '/' do
    get '/'
    assert last_response.ok?
  end


  test '/login' do
    get '/login'
    assert last_response.ok?

    post '/login'
    assert last_response.ok?
  end


  test '/admin' do
    get '/admin'
    assert_equal 404, last_response.status
  end


  test '/api/person' do
    get '/api/person'
    assert_equal 404, last_response.status

    post '/api/person'
    assert_equal 404, last_response.status
  end

  test '/api/event' do
    get '/api/event'
    assert_equal 404, last_response.status

    post '/api/event'
    assert_equal 404, last_response.status
  end


  test '/api/news' do
    get '/api/news'
    assert_equal 404, last_response.status

    post '/api/news'
    assert_equal 404, last_response.status
  end

end
