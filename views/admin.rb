# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class App
  module Views
    class Admin < Layout

      def title
        "Dashboard - Berlin Racing Team"
      end

      def nav_home
        'active'
      end

      def next_events?
        not @next_events.empty?
      end

      def next_events
        @next_events.map do |e|
          {
            id: "event-#{e.id}",
            date: l(e.date, '%e. %b'),
            title: e.title,
            distance: e.distance,
            participationlink: e.participationlink,
            participations: participations(e),
            iparticipate: iparticipate(e.participations)
          }
        end
      end

      def participations(event)
        i = 0
        event.participations.map do |p|
          i += 1
          {
            name: p.person.name,
            me: p.person == current_person,
            last: i == event.participations.count
          }
        end
      end

      def iparticipate(participations)
        participations.each do |p|
          return true if p.person == current_person
        end
      end

    end
  end
end


