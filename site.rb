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

  DataMapper::Logger.new($stdout, :debug) if development?
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db/local.db?encoding=utf8')

  # /
  on get, path('') do
    @news = News.all(:date.lte => Date.today, :order => [:date.desc, :updated_at.desc],
                     :limit => 4)
    res.write render 'views/index.slim'
  end


  # /login
  on get, path('login') do
    unless current_person
      res.header['WWW-Authenticate'] = %(Basic realm='Berlin Racing Team')
      res.status = 401
      res.write 'Wir haben Dich trotzdem gern.'
    else
      res.redirect '/'
    end
  end


  # /kontakt
  on path('kontakt') do
    # GET
    on get do
      @email = Email.new()
      res.write render 'views/kontakt.slim'
    end

    # POST
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


  # /news/new
  on path('news'), path('new') do
    # GET
    on get do
      break unless has_admin?
      @news = News.new()
      res.write render 'views/news_form.slim'
    end

    # POST
    on post, param('news') do |news|
      break unless has_admin?
      @news = News.new(news)
      @news.person = current_person
      if @news.save
        res.redirect @news.permalink
      else
        res.write render 'views/news_form.slim'
      end
    end
  end

  # /news
  on path('news') do
    break
  end


  # /rennen/new
  on path('rennen'), path('new') do
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

  # /rennen
  on path('rennen') do
    break
  end


  # /team
  on path('team') do
    # /team
    on get, path('') do
      @people = Person.all(:order => [:last_name, :first_name])
      res.write render 'views/people.slim'
    end

    # /team/new
    on path('new') do
      break unless has_admin?
      on get, path('') do
        @person = Person.new
        res.write render 'views/person_form.slim'
      end

      on post, path(''), param('person') do |p|
        @person = Person.new(p)

        if @person.save
          res.redirect @person.permalink
        else
          res.write render 'views/person_form.slim'
        end
      end
    end

    # /team/first-last
    on segment do |slug|
      break not_found unless @person = Person.first(:slug => slug)

      # /team/first-last
      on get, path('') do
        res.write 'found'
      end

      # /team/first-last/edit
      on path('edit') do
        break not_found unless @person == current_person or has_admin?
        # /team/first-last/edit
        on get, path('') do
          res.write render 'views/person_form.slim'
        end

        on post, path(''), param('person') do |p|
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
      # edit
    end
    # first-last
  end
  # end /team


  # /css/styles.css
  on path('css'), path('styles.css') do
    res.write stylesheet('css/styles.scss')
  end


  # 404
  on default do
    not_found
  end

end

