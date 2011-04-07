# coding:utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


# SET RACK_ENV to test
ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require './app'
require 'test/unit'
require 'rack/test'

# create dummy user for testing authenticated views
Person.create(first_name: 'Dummy', last_name: 'User', email: 'dummy@user.com',
              password: 'test123', password_confirmation: 'test123')


#DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite3:db/test.db?encoding=utf8')

