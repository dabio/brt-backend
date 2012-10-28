# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class Event
  include DataMapper::Resource

  attr_accessor :index, :new_month

  property :id,         Serial
  property :date,       Date,   required: true
  property :title,      String, required: true, length: 250
  property :url,        URI
  property :distance,   Integer,required: true
  property :type,       Integer, default: 1 #Enum[:race, :training], default: :race
  timestamps :at
  property :slug,       String, length: 2000, default: lambda { |r, p|
    r.title.to_url
  }
  belongs_to :person
  has 1, :news
  has n, :reports
  has n, :comments
  has n, :participations
  has n, :people, :through => :participations

  #validates_presence_of :date, :title, :distance#, :type

  default_scope(:default).update(order: [:date, :updated_at.desc])

#  after :save do |event|
#    # save link in mixing table
#    Mixing.first_or_create(:event => event).update(:date => event.date)
#  end

  def date_formatted
    R18n::l(date, :human)
  end

  def editlink
    "/admin/events/#{id}"
  end

end

