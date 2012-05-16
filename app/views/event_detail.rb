# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

module Brt
  module Views
    class EventDetail < Layout

      def title
        "#{@event.title} - Berlin Racing Team"
      end

      def nav_rennen
        'active'
      end

      def link_to_year
        "/rennen/#{@event.date.year}"
      end

      def event
        {
          title: @event.title,
          date: l(@event.date, :full),
          distance: @event.distance,
          permalink: @event.permalink,
          editlink: @event.editlink,
          deletelink: @event.deletelink,
        }
      end

      def participations?
        not @event.participations.empty?
      end

      def participations
        @event.participations.map do |p|
          {
            person: person(p.person),
            position_overall: p.position_overall,
            position_age_class: p.position_age_class
          }
        end
      end

      def person(p)
        return nil unless p
        {
          name: p.name,
          permalink: p.permalink
        }
      end

    end
  end
end



