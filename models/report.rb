# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class Report
  include DataMapper::Resource

  property :id,     Serial
  property :date,   Date
  property :text,   Text
  timestamps :at

  belongs_to :person
  belongs_to :event

  validates_presence_of :date, :text

  def permalink
    "/reports/#{id}"
  end

  def editlink
    "#{permalink}/edit"
  end

end

