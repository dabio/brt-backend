require 'bundler/setup'

RACK_ENV = 'test'
Bundler.require(:default, RACK_ENV)

#require 'simplecov'
#SimpleCov.start

require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))

require 'boot'
include Rack::Test::Methods

def app
  Brt::App
end
