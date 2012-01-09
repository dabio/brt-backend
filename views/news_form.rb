# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class App
  module Views
    class NewsForm < Layout

      def title
        if new?
          "Neue Meldung anlegen - Berlin Racing Team"
        else
          "Bearbeiten: #{@news.title} - Berlin Racing Team"
        end
      end

      def nav_news
        'active'
      end

      def new?
        @news.new?
      end

      def news
        return nil unless @news
        {
          title: @news.title,
          teaser: @news.teaser,
          message: @news.message,
          date: new? ? today.strftime('%Y-%m-%d') : @news.date.strftime('%Y-%m-%d'),
          event: event,
          errors: errors,
          save_link: new? ? @news.createlink : @news.editlink
        }
      end

      def errors?
        not errors.nil?
      end

      def errors
        return nil unless @news.errors.length > 0
        @news.errors.map do |e|
          {
            message: e[0]
          }
        end
      end

      def event
        return nil unless @news.event
        {
          date: l(@news.event.date, :full),
          distance: @news.event.distance,
          participations: participations
        }
      end

      def events
        return nil unless @events

        # insert currently selected event
        @events.insert(0, @news.event) unless @news.event.nil? or new?

        @events.map do |e|
          {
            title: e.title,
            distance: e.distance,
            date: "#{e.date.strftime('%d')}. #{month_short(e.date)} #{e.date.strftime('%Y')}",
            id: e.id,
            selected: @news.event ? e.id == @news.event.id : false
          }
        end
      end

      def participations?
        not participations.empty?
      end

      def participations
        @news.event.participations.map do |p|
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

