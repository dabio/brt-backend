source :rubygems

gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-r18n', require: 'sinatra/r18n'
gem 'sinatra-flash', require: 'sinatra/flash'
gem 'mustache', require: 'mustache/sinatra'
gem 'rack-force_domain'
gem 'rack-timeout', require: 'rack/timeout'
gem 'dm-core'
gem 'dm-aggregates'
gem 'dm-migrations', require: false
gem 'dm-timestamps'
gem 'dm-validations'
gem 'bcrypt-ruby', require: 'bcrypt'
gem 'unidecode'
gem 'rake'
gem 'redcarpet'
gem 'thin', require: false

group :development, :test do
  gem 'dm-sqlite-adapter'
  gem 'sinatra-contrib', require: 'sinatra/reloader'
  #gem 'shotgun', require: false
  gem 'heroku', require: false
  gem 'foreman', require: false
  gem 'sass', require: false
  gem 'rb-fsevent', require: false
  gem 'simplecov', require: false
  gem 'rack-test', require: false
  gem 'taps', require: false, git: 'git@github.com:dabio/taps.git'
end

group :production do
  gem 'dm-postgres-adapter'
  gem 'newrelic_rpm'
end

