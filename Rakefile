# coding:utf-8

$LOAD_PATH.unshift(File.expand_path('../lib', File.dirname(__FILE__)))

task :test do
  require 'cutest'

  Cutest.run(Dir['test/*.rb'])
end

task :news do
  require './site'
  DataMapper::Logger.new($stdout, :debug) unless production?
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db/local.db')

  @person = Person.first(:id => 1)
  @news = News.new(
    :date => '2011-01-08',
    :title => 'Jens Heller startet 2011 wieder für das Berlin Racing Team',
    :message => 'Teamgründer Jens Heller wird in der kommenden Saison wieder zum Berlin Racing Team zurückkehren.')
  @news.person = @person
  @news.save
end

task :default => :test

