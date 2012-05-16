source 'http://rubygems.org'

ruby '1.9.3'

gem 'bcrypt-ruby', require: 'bcrypt'
gem 'dm-core'
gem 'dm-aggregates'
gem 'dm-migrations', require: false
gem 'dm-postgres-adapter'
gem 'dm-timestamps'
gem 'dm-validations'
gem 'json'
gem 'mustache', require: 'mustache/sinatra'
gem 'rack-force_domain'
gem 'rack-timeout', require: 'rack/timeout'
gem 'redcarpet'
gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-r18n', require: 'sinatra/r18n'
gem 'sinatra-flash', require: 'sinatra/flash'
gem 'stringex'
gem 'thin', require: false

group :development do
  gem 'heroku', require: false
  gem 'foreman', require: false
  gem 'sass', require: false
  gem 'rb-fsevent', require: false
  gem 'simplecov', require: false
  gem 'taps', require: false, git: 'git@github.com:dabio/taps.git'
  gem 'shotgun', require: false
end

group :test do
  gem 'rack-test', require: 'rack/test'
end

group :production do
#  gem 'newrelic_rpm'
end
