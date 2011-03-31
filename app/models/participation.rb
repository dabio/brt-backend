# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class Participation
  include DataMapper::Resource

  property :person_id,  Integer, :key => true
  property :event_id,   Integer, :key => true
  property :position_overall,   Integer
  property :position_age_class, Integer
  timestamps :at

  belongs_to :person,   :key => true
  belongs_to :event,    :key => true

  def self.get_person_results(person_id)
    # select out results from database with a sql
    result = repository(:default).adapter.select('SELECT events.title, events.date, events.distance, position_overall, position_age_class FROM participations JOIN events ON participations.event_id = events.id WHERE participations.person_id = ? AND events.date <= ? AND position_overall ORDER BY events.date DESC;', person_id, Date.today)

    # convert string date to Date object
    result.each { |item| item.date = Date.parse(item.date) }
  end

end

