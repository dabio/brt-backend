# coding:utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


task :default => :test
task :test do
  require './shotgun'
  require 'cutest'

  ENV['RACK_ENV'] = "test"
  Cutest.run(Dir['test/test_*.rb'])
end


task :uninstall do
  system "rvm", "--force", "gemset", "empty"
  File.unlink "Gemfile.lock"
end
task :install do
  system "gem", "install", "bundler"
  system "bundle", "install", "--without", "production"
end


namespace "db" do
  task :prepare do
    require './shotgun'
    DataMapper::Logger.new($stdout, :debug) unless production?
    DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db/local.db?encoding=utf8')
  end

  desc 'Create the database tables.'
  task :migrate => :prepare do
    require 'dm-migrations'
    DataMapper.auto_migrate!
  end

  desc 'Upgrade the database tables.'
  task :upgrade => :prepare do
    require 'dm-migrations'
    DataMapper.auto_upgrade!
  end

  desc 'Pull database from heroku'
  task :pull do
    system "heroku", "db:pull", "sqlite://db/local.db"
  end

  desc 'Push database to heroku'
  task :push do
    system "heroku", "db:push", "sqlite://db/local.db"
  end
end

