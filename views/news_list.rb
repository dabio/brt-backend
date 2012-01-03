# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class App
  module Views
    class NewsList < Layout

      def title
        'Nachrichten & Rennberichte - Berlin Racing Team'
      end

      def nav_news
        'active'
      end

      def news
        @news.each do |news|
          unless news.teaser.length > 0
            news.teaser = StringHelpers::truncate_words(news.message, 40)
          end
        end
      end

      def page
        @page
      end

      def page_count
        @count
      end

      def pagination?
        @count > 1
      end

      def pagination
        Array.new(page_count) do |i|
          if i+1 == page
            {title: i+1}
          elsif i == 0
            {title: i+1, href: '/news'}
          else
            {title: i+1, href: "/news?page=#{i+1}"}
          end
        end
      end

      def pagination_left_right
        result = []
        # back
        if page == 1
          result << {title: '«'}
        elsif page == 2
          result << {title: '«', href: '/news'}
        else
          result << {title: '«', href: "/news?page=#{page-1}"}
        end
        # forward
        if page == page_count
          result << {title: '»'}
        else
          result << {title: '»', href: "/news?page=#{page+1}"}
        end
        result
      end

    end
  end
end

