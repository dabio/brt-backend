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
    DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db/local.db')
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

  task :news => :prepare do
    @p = Person.first(:id => 1)
    @news = News.new(:date => '2011-01-08',
        :title => 'Jens Heller startet 2011 wieder für das Berlin Racing Team',
        :message => 'Teamgründer Jens Heller wird in der kommenden Saison wieder für das Berlin Racing Team fahren.',
        :person => @p)
    @news.save()
    puts @p
    puts @news
  end
end

