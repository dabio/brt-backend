# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

module Brt
  module Views
    class Index < Layout

      def nav_home
        "active"
      end

      def news
        index = -1
        class_name = 'news-box'
        class_name_last = "#{class_name}-last"
        @news.map do |n|
          index += 1
          {
            title: n.title,
            permalink: n.permalink,
            teaser: n.teaser,
            date_formatted: l(n.date, :full),
            class_name: index % 3 == 2 ? class_name_last : class_name,
            divider: index == 2
          }
        end
      end

    end
  end
end
