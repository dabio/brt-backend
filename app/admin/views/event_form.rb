module Brt
  module Views
    class EventForm < AdminLayout

      def title
        'Rennen'
      end

      def event
        @event
      end

      def participations?
        !event.new?
      end

      def non_participations
        Person.all - event.participations.person
      end

    end
  end
end
