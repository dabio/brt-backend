# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


class Event
  include DataMapper::Resource

  property :id,         Serial
  property :date,       Date
  property :title,      String, length: 250
  property :url,        URI
  property :distance,   Integer
  property :type,       Enum[:race, :training], default: :race
  timestamps :at
  property :slug,       String, length: 2000, default: lambda { |r, p| slugify r.title }
 
  belongs_to :person
  has n, :reports
  has n, :comments
  has n, :participations
  has n, :people, :through => :participations

  validates_presence_of :date, :title, :distance#, :type

#  after :save do |event|
#    # save link in mixing table
#    Mixing.first_or_create(:event => event).update(:date => event.date)
#  end

  def permalink
    "/rennen/#{date.strftime("%Y/%m/%d")}/#{slug}"
  end

  def editlink
    "#{permalink}/edit"
  end
end

