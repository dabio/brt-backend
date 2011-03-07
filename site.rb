﻿# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

require './shotgun'

Cuba.use Rack::ForceDomain, ENV["DOMAIN"]
Cuba.use Rack::R18n, :default => 'de'

class Cuba::Ron
  include R18n::Helpers
  include Cuba::Prelude

  DataMapper::Logger.new($stdout, :debug) if development?
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db/local.db?encoding=utf8')
end

Cuba.define do
  # /
  on '' do
    @news = News.all(:date.lte => Date.today, :order => [:date.desc, :updated_at.desc],
                     :limit => 4)
    res.write render 'views/index.slim'
  end


  # /login
  on 'login' do
    unless current_person
      res.header['WWW-Authenticate'] = %(Basic realm='Berlin Racing Team')
      res.status = 401
      res.write 'Wir haben Dich trotzdem gern.'
    else
      res.redirect '/'
    end
  end


  # /kontakt
  on 'kontakt' do

    on get do
      @email = Email.new()
      res.write render 'views/kontakt.slim'
    end

    on post, param('contact'), param('email') do |contact, email|
      break unless email.length == 0

      @email = Email.new(contact)
      if @email.save
        send_email(ENV['CONTACT_EMAIL'],
                   :from => @email.email,
                   :from_alias => @email.name,
                   :subject => 'Nachricht von berlinracingteam.de',
                   :body => @email.message)
        @email.update(:send_at => Time.now)
        res.redirect '/kontakt'
      else
        res.write render 'views/kontakt.slim'
      end
    end

  end


  on 'news/new' do
    break unless has_admin?

    on get do
      @news = News.new()
      res.write render 'views/news_form.slim'
    end

    on post, param('news') do |news|
      @news = News.new(news)
      @news.person = current_person
      if @news.save
        res.redirect @news.permalink
      else
        res.write render 'views/news_form.slim'
      end
    end

  end

  on 'news' do
    break
  end


  on 'rennen/new' do
    break unless has_admin?

    on get do
      @event = Event.new()
      res.write render 'views/event_form.slim'
    end

    # POST
    on post, param('event') do |event|
      @event = Event.new(event)
      @event.person = current_person
      if @event.save
        res.redirect @event.permalink
      else
        res.write render 'views/event_form.slim'
      end
    end

  end

  on 'rennen/:y/:m/:d/:slug' do |y, m, d, slug|
    @event = Event.first(:date => Date.new(y.to_i, m.to_i, d.to_i), :slug => slug)
    break not_found unless @event

    on get do
      res.write render 'views/event.slim'
    end

    on post do
      break not_found unless has_auth?
      Participation.create(:person => current_person, :event => @event)
    end

    on delete do
      break not_found unless has_auth?
      Participation.all(:person => current_person, :event => @event).destroy!
    end

    on 'edit' do
      break not_found unless has_admin?

      on get do
        res.write render 'views/event_form.slim'
      end

      on post, param('event') do |e|
        @event.attributes = {
          :date => e['date'],
          :title => e['title'],
          :url => e['url'],
          :distance => e['distance']
        }

        if @event.save
          res.redirect @event.permalink
        else
          res.write render 'views/event_form.slim'
        end
      end
    end
  end

  on 'rennen' do
    today = Date.today
    @events = Event.all(:date.gte => "#{today.year}-01-01",
                        :date.lte => "#{today.year}-12-31",
                        :order => [:date, :updated_at.desc])
    res.write render 'views/events.slim', :today => today
  end


  on 'team/new' do
    break unless has_admin?

    on get do
      @person = Person.new
      res.write render 'views/person_form.slim'
    end

    on post, param('person') do |p|
      @person = Person.new(p)

      if @person.save
        res.redirect @person.permalink
      else
        res.write render 'views/person_form.slim'
      end
    end
  end

  on 'team/:slug' do |slug|
    break unless @person = Person.first(:slug => slug)

    on '' do
      res.write 'found'
    end

    on 'edit' do
      on get do
        break unless @person == current_person or has_admin?
        res.write render 'views/person_form.slim'
      end

      on post, param('person') do |p|
        @person.attributes = {
          :email  => p['email'],
          :info   => p['info']
        }

        unless p['password'].empty?
          @person.password = p['password']
          @person.password_confirmation = p['password_confirmation']
        end

        if @person.save
          res.redirect @person.permalink
        else
          res.write render 'views/person_form.slim'
        end
      end
    end
  end

  on 'team' do
    @people = Person.all(:order => [:last_name, :first_name])
    res.write render 'views/people.slim'
  end


  # /css/styles.css
  on 'css/styles.css' do
    res.write stylesheet('css/styles.scss')
  end


  # 404
  on default do
    not_found
  end

end

