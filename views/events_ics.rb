# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class App
  module Views
    class EventsIcs < Layout

      def events
        @events.map do |e|
          {
            uid: "event-#{e.id}@berlinracingteam.de",
            #attendees: attendees(e),
            ical_timestamp: e.created_at.strftime('%Y%m%dT%H%M%SZ'),
            ical_date_start: e.date.strftime('%Y%m%d'),
            ical_date_end: e.date.+(1).strftime('%Y%m%d'),
            title: e.title
          }
        end
      end

      #def attendees(event)
      #  event.participations.map do |p|
      #    {
      #      name: p.person.name,
      #      email: p.person.email
      #    }
      #  end
      #end

    end
  end
end

