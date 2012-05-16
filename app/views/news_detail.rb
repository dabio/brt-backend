# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

module Brt
  module Views
    class NewsDetail < Layout

      def title
        "#{@news.title} - Berlin Racing Team"
      end

      def nav_news
        'active'
      end

      def news
        return nil unless @news
        {
          title: @news.title,
          permalink: @news.permalink,
          editlink: @news.editlink,
          deletelink: @news.deletelink,
          teaser: @news.teaser,
          message: markdown(@news.message),
          author: person(@news.person),
          date: l(@news.date, :full),
          event: event,
        }
      end

      def event
        return nil unless @news.event
        {
          date: l(@news.event.date, :full),
          distance: @news.event.distance,
          participations: participations
        }
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




