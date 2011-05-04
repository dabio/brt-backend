source :rubygems

gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-r18n', require: 'sinatra/r18n'
gem 'sinatra-flash', require: 'sinatra/flash'
gem 'slim'
gem 'sass'
gem 'rack-force_domain'
gem 'rack-timeout', require: 'rack/timeout'
gem 'dm-core'
gem 'dm-timestamps'
gem 'dm-validations'
gem 'bcrypt-ruby', require: 'bcrypt'
gem 'unidecode'
gem 'redcarpet'
gem 'newrelic_rpm'

group :development, :test do
  gem 'dm-sqlite-adapter'
  gem 'shotgun', require: false
  gem 'heroku', require: false
  gem 'simplecov', require: false
  gem 'rack-test', require: false
end

group :production do
  gem 'dm-postgres-adapter'
end
