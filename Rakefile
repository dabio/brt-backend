# coding:utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

require './shotgun'

task :default => :test
task :test do
  require 'cutest'

  Cutest.run(Dir['test/*.rb'])
end


namespace "db" do
  task :prepare do
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
end
