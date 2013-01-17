# encoding: utf-8

module Brt
  module Views
    class TidingsForm < AdminLayout

      def title
        'Nachricht oder Rennbericht'
      end

      def news
        @news
      end

      def events
        # insert currently selected event
        unless news.event.nil? or news.new?
          news.event.selected = true
          @events.insert(0, news.event)
        end
        @events
      end

      def javascripts
        js :zepto, :admin
      end

    end
  end
end