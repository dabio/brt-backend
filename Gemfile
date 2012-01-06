source :rubygems

gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-r18n', require: 'sinatra/r18n'
gem 'sinatra-flash', require: 'sinatra/flash'
#gem 'sinatra-synchrony', require: 'sinatra/synchrony'
#gem 'slim'
gem 'mustache', require: 'mustache/sinatra'
gem 'sass'
gem 'sprockets'
gem 'rack-force_domain'
gem 'rack-timeout', require: 'rack/timeout'
gem 'dm-core'#, '~> 1.1.0'
gem 'dm-aggregates'#, '~> 1.1.0'
gem 'dm-timestamps'#, '~> 1.1.0'
gem 'dm-validations'#, '~> 1.1.0'
gem 'bcrypt-ruby', require: 'bcrypt'
gem 'unidecode'
gem 'redcarpet'

group :development, :test do
  gem 'dm-sqlite-adapter'
  #gem 'sinatra-contrib', require: 'sinatra/reloader'
  gem 'shotgun', require: false
  gem 'heroku', require: false
  gem 'simplecov', require: false
  gem 'rack-test', require: false
  gem 'thin', require: false
end

group :production do
  gem 'dm-postgres-adapter'
  gem 'newrelic_rpm'
end
