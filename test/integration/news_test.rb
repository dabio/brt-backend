require File.expand_path('../../helper', __FILE__)

context 'NewsApp' do

  def app
    Brt::NewsApp
  end

  setup do; end

  test '/news as public user' do
    get '/news'
    assert !last_response.ok?
    assert last_response.headers['Location'].include?('/login')

    post '/news'
    assert !last_response.ok?
    assert last_response.headers['Location'].include?('/login')
  end

  test '/news/5 as public user' do
    get '/news/5'
    assert !last_response.ok?
    assert last_response.headers['Location'].include?('/login')
  end

end
