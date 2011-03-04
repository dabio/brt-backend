require File.expand_path('../site', File.dirname(__FILE__))
require 'cuba/test'

setup do
  ENV['RACK_ENV'] = 'test'
end
