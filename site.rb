# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

require_relative 'models'


module Sinatra
  module PersonHelper

    # This gives us the currently logged in user. We keep track of that by just
    # setting a session variable with their is. If it doesn't exist, we want to
    # return nil.
    def current_person
      @cp = Person.first(:id => session[:person_id]) if session[:person_id] unless @cp
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
    
    def footer
      @events = Event.all(:date.gte => Date.today, :order => [:date, :updated_at.desc],
                          :limit => 3)
      @people ||= Person.all(:order => [:last_name, :first_name])
      slim :_footer
    end

    def today
      @today = Date.today unless @today
      @today
    end

  end

  helpers TemplateHelper

end


class BerlinRacingTeam < Sinatra::Base
  register Sinatra::R18n

  set :root, File.dirname(__FILE__)
  set :cdn, '//berlinracingteam.commondatastorage.googleapis.com'

  helpers Sinatra::PersonHelper
  helpers Sinatra::TemplateHelper

  get '/' do
    @news = News.all(:date.lte => today, :order => [:date.desc, :updated_at.desc],
                     :limit => 3)
    slim :index
  end

end

