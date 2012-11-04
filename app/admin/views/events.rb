# encoding: utf-8

module Brt
  module Views
    class Events < AdminLayout

      def title
        'Rennen'
      end

      def page
        @page
      end

      def page_count
        @count
      end

      def pagination?
        page_count > 1
      end

      def pagination
        Array.new(page_count) do |i|
          if i+1 == page
            { title: i+1 }
          elsif i == 0
            { title: i+1, href: '/admin/events' }
          else
            { title: i+1, href: "/admin/events?page=#{i+1}" }
          end
        end
      end

      def pagination_left_right
        result = []
        # back
        if page == 1
          result << { title: '«' }
        elsif page == 2
          result << { title: '«', href: '/admin/events' }
        else
          result << { title: '«', href: "/admin/events?page=#{page-1}" }
        end
        # forward
        if page == page_count
          result << { title: '»' }
        else
          result << { title: '»', href: "/admin/events?page=#{page+1}" }
        end
        result
      end

    end
  end
end
