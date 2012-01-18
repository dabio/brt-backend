# coding:utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


#
# Tests
#

task :default => :test
task :test do
  require 'fileutils'
  require 'rake/testtask'

  # copy actual database file aside for testing
  FileUtils.cp 'db/local.db', 'db/test.db'

  Rake::TestTask.new do |t|
    t.libs << 'test'
    t.pattern = 'test/test_*.rb'
    t.verbose = true
  end

end


#
# Install/Uninstall
#

task :uninstall do
  system "rvm", "--force", "gemset", "empty"
  File.unlink "Gemfile.lock"
end

task :install do
  system "gem", "install", "bundler"
  system "bundle", "install", "--without", "production"
end


#
# Environment
#

task :environment do
  require File.join(File.dirname(__FILE__), 'env.rb')
end


namespace "db" do

  task :load_migrations => :environment do
    require 'dm-migrations'
    require 'dm-migrations/migration_runner'
    FileList['db/migrate/*.rb'].each do |migration|
      load migration
    end
  end

  desc 'List migrations descending, showing which have been applied'
  task :migrations => :load_migrations do
    puts migrations.sort.reverse.map {|m| "#{m.position}  #{m.name}  #{m.needs_up? ? '' : 'APPLIED'}"}
  end

  desc "Run all pending migrations, or up to specified migration"
  task :migrate, [:version] => :load_migrations do |t, args|
    if vers = args[:version] || ENV['VERSION']
      puts "=> Migrating up to version #{vers}"
      migrate_up!(vers)
    else
      puts "=> Migrating up"
      migrate_up!
    end
    puts "<= #{t.name} done"
  end

  desc 'Auto-migrate the database (destroys data)'
  task :bootstrap => :load_migrations do
    puts "Bootstrapping database..."
    DataMapper.auto_migrate!
  end

  desc 'Upgrade the database tables.'
  task :upgrade => :environment do
    adapter = DataMapper.repository(:default).adapter
    adapter.execute('ALTER TABLE news ADD COLUMN `teaser` text NOT NULL DEFAULT \'\';')
    adapter.execute('ALTER TABLE news ADD COLUMN `event_id` integer;')
    adapter.execute('INSERT INTO news (date, title, message, slug, event_id, person_id, created_at, updated_at) SELECT r.date, e.title, r.text, e.slug, r.event_id, r.person_id, r.created_at, r.updated_at FROM reports AS r JOIN events AS e ON r.event_id = e.id;')
    adapter.execute('DELETE FROM reports;')
  end

  desc 'Pull database from heroku'
  task :pull do
    system "heroku", "db:pull", "sqlite://db/local.db?encoding=utf8"
  end

  desc 'Push database to heroku'
  task :push do
    system "heroku", "db:push", "sqlite://db/local.db?encoding=utf8"
  end

end

