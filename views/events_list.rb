# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class App
  module Views
    class EventsList < Layout

      def title
        "Rennkalender #{active_year} - Berlin Racing Team"
      end

      def nav_rennen
        "active"
      end

      def active_year
        events[0].date.year
      end

      def events
        index = 0
        @events.each_with_index do |event, i|
          if i == 0
            event.new_month = l event.date, :month
          elsif @events[i-1].date.month < event.date.month
            index = 0
            event.new_month = l event.date, :month
          end
          event.index = index
          index += 1
        end
        @events
      end

    end
  end
end


