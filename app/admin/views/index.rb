# encoding: utf-8

module Brt
  module Views
    class Index < AdminLayout

      def title
        'Dashboard'
      end

      def events
        @events.map do |e|
          {
            id: e.id,
            participations: e.participations,
            date_formatted: e.date_formatted,
            title: "#{e.title}, #{e.distance} km",
            my_participation: e.for_person(current_person),
            participation_createlink: e.participation_createlink
          }
        end
      end

      def javascripts
        js :zepto, :admin
      end

    end
  end
end
