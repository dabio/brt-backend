source :rubygems

gem "sinatra"
gem "sinatra-r18n", :require => "sinatra/r18n"
gem "sinatra-flash", :require => "sinatra/flash"
gem "slim"
gem "sass"
gem "rack-force_domain"
gem "dm-core"
gem "dm-timestamps"
gem "dm-validations"
gem "bcrypt-ruby", :require => "bcrypt"
gem "unidecode"

group :development, :test do
  gem "dm-sqlite-adapter"
  gem "shotgun"
  gem "heroku"
  gem "rack-test"
end

group :production do
  gem "dm-postgres-adapter"
end
