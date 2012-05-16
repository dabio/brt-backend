# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

module Brt
  module Views
    class PeopleList < Layout

      def nav_team
        "active"
      end

      def title
        'Team - Berlin Racing Team'
      end

      def people
        @people.each_index { |i| @people[i].index = i }
        @people
      end

    end
  end
end

