require File.expand_path('../../helper', __FILE__)

context 'App' do

  setup do; end

  test '/' do
    get '/'
    assert !last_response.ok?
  end

  test '/login' do
    get '/login'
    assert last_response.ok?

    post '/login'
    assert last_response.status == 302
  end

  test '/logout' do
    get '/logout'
    assert !last_response.ok?
  end

end
