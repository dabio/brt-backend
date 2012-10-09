# encoding: utf-8

module Brt
  module Views
    class Layout < Mustache

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
