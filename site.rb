# encoding: utf-8
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
    @news = News.all(:date.lte => Date.today, :order => [:date.desc, :updated_at.desc],
                     :limit => 4)
    res.write render 'views/index.slim'
  end

  # /kontakt
  on path('kontakt') do
    on get do
      @email = Email.new()
      res.write render 'views/kontakt.slim'
    end

    on post, param('contact'), param('email') do |contact, email|
      break not_found unless email.length == 0

      @email = Email.new(contact)
      if @email.save
        send_email(ENV['CONTACT_EMAIL'], :from => @email.email, :from_alias => @email.name, :subject => 'Nachricht vom berinracingteam.de', :body => @email.message)
        @email.update(:send_at => Time.now)
        res.redirect '/kontakt'
      else
        res.write render 'views/kontakt.slim'
      end
    end
  end

  # /news
  on path('news') do
    on path('new') do
      on get do
        @news = News.new()
        res.write render 'views/news_form.slim'
      end

      on post, param('news') do |news|
        @news = News.new(news)
        @news.person = Person.first(:id => 1)
        if @news.save
          res.redirect @news.permalink
        else
          res.write render 'views/news_form.slim'
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



