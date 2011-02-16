#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#
require './shotgun'

Cuba.use Rack::NoWWW
Cuba.use Rack::R18n, :default => 'de'

Cuba.define do
  extend R18n::Helpers
  extend Cuba::Prelude

  DataMapper::Logger.new($stdout, :debug) unless production?
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db/local.db')

  # /index.html
  on path('') do
    today = Date.today
    @news = News.all(:date.lte => today, :order => [:date.desc, :updated_at.desc],
                     :limit => 4)
    slim 'index'
  end

  # /css/styles.css
  on path('css'), path('styles.css') do
    res.write stylesheet('css/styles.scss')
  end

  # 404
  on default do
    not_found
  end
end



