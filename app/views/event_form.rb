# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

module Brt
  module Views
    class EventForm < Layout

      def title
        if new?
          "Neues Rennen - Berlin Racing Team"
        else
          "Bearbeiten: #{ @event.title } - Berlin Racing Team"
        end
      end

      def nav_rennen
        'active'
      end

      def new?
        @event.new?
      end

      def event
        return nil unless @event
        {
          title: @event.title,
          date: new? ? today : @event.date,
          url: @event.url,
          distance: @event.distance,
          savelink: new? ? @event.createlink : @event.editlink
        }
      end

      def errors?
        not errors.nil?
      end

      def errors
        return nil unless @event.errors.length > 0
        @event.errors.map do |e|
          {
            message: e[0]
          }
        end
      end

    end
  end
end



