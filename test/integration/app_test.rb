require File.expand_path('../../helper', __FILE__)

context 'App' do

  def app
    Brt::App
  end

  setup do; end

  test '/' do
    get '/'
    assert !last_response.ok?
  end

  test '/login' do
    get '/login'
    assert last_response.ok?
    assert last_response.body.include?('!DOCTYPE html')
    assert last_response.body.include?('Anmelden')
  end

  test '/login' do
    post '/login'
    assert last_response.headers['Location'].include?('/login')
    assert_equal last_response.status, 302
  end

  test '/logout' do
    get '/logout'
    assert last_response.headers['Location'].include?('/login')
    assert_equal last_response.status, 302
  end

  test 'wrong credentials' do
    post '/login', { email: 'dummy@user.com', password: 'blabla' }
    assert last_response.ok?
    assert last_response.body.include?('Unbekannte E-Mail oder falsches Password')
  end

end
