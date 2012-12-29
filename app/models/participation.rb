# encoding: utf-8

class Participation
  include DataMapper::Resource

  property :id,         Serial
  property :person_id,  Integer
  property :event_id,   Integer
  property :position_overall,   Integer
  property :position_age_class, Integer
  # this property is needed only for ordering the participation on the person
  # detail view
  property :date,       Date
  timestamps :at

  belongs_to :person
  belongs_to :event

  before :save do |p|
    # this hook adds the event date to this participation. this is needed to
    # order the participations on a person detailed page.
    p.date = p.event.date
  end

  default_scope(:default).update(order: [:date.desc, :position_overall])

  def self.createlink
    '/admin/participations'
  end

  def createlink
    Participation.createlink
  end

  def deletelink
    "#{createlink}/#{id}"
  end

end

