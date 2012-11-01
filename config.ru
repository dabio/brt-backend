require File.expand_path(File.dirname(__FILE__) + '/app/boot')

map '/admin' do
  run Brt::Admin
end

#map '/api' do
#  run Brt::Api
#end

map '/' do
  run Brt::Frontend
end
