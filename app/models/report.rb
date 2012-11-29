# encoding: utf-8

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

