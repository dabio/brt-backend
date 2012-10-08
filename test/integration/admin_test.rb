require File.expand_path('../../helper', __FILE__)

context 'Admin' do

  setup do; end


  test '/admin' do
    get '/admin'
    assert_equal 404, last_response.status
  end


end
