source "https://rubygems.org/"
ruby '2.1.1'

gem 'dm-core'
gem 'dm-aggregates'
gem 'dm-migrations', require: false
gem 'dm-postgres-adapter'
gem 'dm-timestamps'
gem 'dm-serializer', require: 'dm-serializer/to_json'
gem 'dm-validations'
gem 'json'
gem 'rack-force_domain'
gem 'rack-timeout', require: 'rack/timeout'
gem 'redcarpet'
gem 'scrypt', '1.1.0'
gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-r18n', require: 'sinatra/r18n'
gem 'sinatra-flash-nicer', require: 'sinatra/flash'
gem 'sinatra-redirect-with-flash', require: 'sinatra/redirect_with_flash'
gem 'stringex'
gem 'puma', require: false

group :development do
  gem 'shotgun', require: false
end

group :test do
  gem 'rack-test', require: 'rack/test'
  gem 'rake', require: false
  gem 'simplecov'
end

group :production do
  gem 'newrelic_rpm'
end
