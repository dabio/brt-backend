# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class App
  module Views
    class Layout < Mustache
      include ViewHelpers

      def title
        @title || 'Berlin Racing Team'
      end

      def team
        Person.all
      end

      def has_next_races
        next_races.length > 0
      end

      def next_races
        Event.all(:date.gte => Date.today, limit: 3).map do |e|
          {
            title: e.title,
            date: l(e.date, :full)
          }
        end
      end

      def flash
        @flash
      end

      def today
        Date.today
      end

      def copyright_year
        today.year
      end

      def header?
        return !@is_admin
      end

      def footer?
        return !@is_admin
      end

    end
  end
end
