# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

require 'bundler'
Bundler.require

require_relative 'models/init'


module Sinatra
  module MainHelper

    def today
      @today = Date.today unless @today
      @today
    end

  end

  module PersonHelper

    # This gives us the currently logged in user. We keep track of that by just
    # setting a session variable with their is. If it doesn't exist, we want to
    # return nil.
    def current_person
      @cp = Person.first(:id => session[:person_id]) if session[:person_id] unless @cp
      @cp
    end

    # Checks if this is a logged in person
    def has_auth?
      !current_person.nil?
    end

    # Check if current person is logged in and admin
    def has_admin?
      has_auth? && current_person.id == 1
    end

  end

  helpers PersonHelper


  module TemplateHelper

    def coat(file)
      require 'digest/md5'
      hash = Digest::MD5.file("views#{file}").hexdigest[0..4]
      "#{file.gsub(/\.scss$/, '.css')}?#{hash}"
    end

    def footer
      @events = Event.all(:date.gte => today, :order => [:date, :updated_at.desc],
                          :limit => 3)
      @people ||= Person.all(:order => [:last_name, :first_name])
      slim :_footer
    end

  end

  helpers TemplateHelper

end


class BerlinRacingTeam < Sinatra::Base
  register Sinatra::Flash
  register Sinatra::R18n

  use Rack::Session::Cookie

  set :root, File.dirname(__FILE__)
  set :cdn, '//berlinracingteam.commondatastorage.googleapis.com'

  helpers Sinatra::MainHelper
  helpers Sinatra::PersonHelper
  helpers Sinatra::TemplateHelper

  helpers do
    [:development, :production, :test].each do |environment|
      define_method "#{environment.to_s}?" do
        return settings.environment == environment.to_sym
      end
    end
  end

  configure :development do
  end


  get '/' do
    @news = News.all(:date.lte => today, :order => [:date.desc, :updated_at.desc],
                     :limit => 3)
    slim :index
  end


  get '/login' do
    redirect to('/') if has_auth?
    slim :login
  end


  post '/login' do
    params[:email] << '@berlinracingteam.de' unless params[:email]['@']
    @person = Person.authenticate(params[:email], params[:password])

    if @person
      session[:person_id] = @person.id
      redirect to(params[:next])
    else
      flash.now[:error] = 'Unbekannte E-Mail oder falsches Password eingegeben.'
      slim :login
    end
  end


  get '/logout' do
    not_found unless has_auth?
    session[:person_id] = nil
    redirect to('/')
  end


  get '/team' do
    @people = Person.all :order => [:last_name, :first_name]
    slim :people
  end


  get '/team/:slug' do
    not_found unless @person = Person.first(:slug => params[:slug])
    @person.name
  end


  get '/team/:slug/edit' do
    not_found unless @person = Person.first(:slug => params[:slug])

    if @person == current_person or has_admin?
      slim :person_form
    else
      not_found
    end
  end


  post '/team/:slug/edit'do
    not_found unless @person = Person.first(:slug => params[:slug])

    if @person == current_person or has_admin?
      @person.attributes = {
        :email  => params[:person]['email'],
        :info   => params[:person]['info']
      }

      unless params[:person]['password'].empty?
        @person.password = params[:person]['password']
        @person.password_confirmation = params[:person]['password_confirmation']
      end

      if @person.save
        flash.now[:notice] = 'Änderung gesichert.'
        redirect to(@person.permalink)
      else
        slim :person_form
      end
    else
      not_found
    end
  end


  get '/rennen' do
    @events = Event.all(:date.gte => "#{today.year}-01-01",
                        :date.lte => "#{today.year}-12-31",
                        :order => [:date, :updated_at.desc])
    slim :events
  end


  get '/kontakt' do
    @email = Email.new()
    slim :kontakt
  end


  post '/kontakt' do
    raise not_found unless params[:email].length == 0

    @email = Email.new params[:contact]
    if @email.save
      @email.update :send_at => Time.now

      send_email(ENV['CONTACT_EMAIL'], :from => @email.email, :from_alias => @email.name, :subject => 'Nachricht von berlinracingteam.de', :body => @email.message)
      flash.now[:notice] = "#{@email.name}, vielen Dank für deine Nachricht! Wir werden sie so schnell wie möglich beantworten."

      redirect to('/kontakt')
    else
      slim :kontakt
    end
  end


  get '/css/styles.css' do
    cache_control :public, :max_age => 29030400
    scss :'css/styles'
  end


  not_found do
    slim :'404'
  end

end

