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
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db/local.db?encoding=utf8')

  # /index.html
  on path('') do
    today = Date.today
    @news = News.all(:date.lte => today, :order => [:date.desc, :updated_at.desc],
                     :limit => 4)
    slim 'index'
  end

  # /kontakt
  on path('kontakt') do
    on get do
      @email = Email.new()
      slim 'kontakt'
    end

    on post, param('name'), param('email'), param('message') do |n, e, m|
        @email = Email.new(:name => n, :email => e, :message => m)

        if @email.save
          send_email(ENV['CONTACT_EMAIL'],
                     :from => @email.email,
                     :from_alias => @email.name,
                     :subject => 'Nachricht vom berinracingteam.de',
                     :body => @email.message
          )
          @email.update(:send_at => Time.now)
          res.redirect '/kontakt'
        else
          slim 'kontakt'
        end
    end
  end

  # /news
  on path('news') do
    on path('new') do
      on get do
        @news = News.new()
        slim 'news_form'
      end

      on post, param('date'), param('title'), param('message') do |d, t, m|
        @person = Person.first(:id => 1)
        @news = News.new(:date => d, :title => t, :message => m, :person => @person)

        if @news.save
          res.redirect @news.permalink
        else
          slim 'news_form'
        end
      end
    end
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



