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
        'active'
      end

      def active_year
        @events[0].date.year
      end

      def events
        index = 0
        prev_month = @events[0].date.month - 1
        @events.map do |e|
          index = 0 if e.date.month > prev_month
          result = {
            new_month?: index == 0,
            first: index % 4 == 0 ? ' first' : '',
            last: index % 4 == 3 ? ' last' : '',
            month: l(e.date, :month),
            date: l(e.date, :full),
            distance: e.distance,
            title: e.title,
            permalink: e.permalink
          }
          index += 1
          prev_month = e.date.month
          result
        end
        #index = 0
        #@events.each_with_index do |event, i|
        #  if i == 0
        #    event.new_month = l event.date, :month
        #  elsif @events[i-1].date.month < event.date.month
        #    index = 0
        #    event.new_month = l event.date, :month
        #  end
        #  event.index = index
        #  index += 1
        #end
        #@events
        
      end

    end
  end
end


