# encoding: utf-8

module Brt
  module Views
    class AdminLayout < Mustache
      include Brt::Helpers

      def title
        'Berlin Racing Team'
      end

      def path_to(script)
        case script
        when :jquery then '//cdnjs.cloudflare.com/ajax/libs/jquery/1.8.2/jquery.min.js'
        when :zepto then '//cdnjs.cloudflare.com/ajax/libs/zepto/1.0rc1/zepto.min.js'
        when :underscore then '//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.1/underscore-min.js'
        #when :backbone then '//cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.2/backbone-min.js'
        else "/js/#{script}.js"
        end
      end

      def js(*args)
        js = args
        js.flatten.uniq.map do |script|
          "<script src=#{path_to script}></script>"
        end.join
      end

      def javascripts; end

      def production?
        RACK_ENV == 'production'
      end

      def development?
        RACK_ENV == 'development'
      end

      def notice
        flash[:notice]
      end

      def warning
        flash[:warning]
      end

      def error
        flash[:error]
      end


      def navigation
        nav = [
          {
            'href'  => '/admin',
            'title' => 'Dashboard'
          },
          {
            'href'  => '/admin/news',
            'title' => 'News & Rennberichte'
          },
          {
            'href'  => '/admin/events',
            'title' => 'Rennen'
          }
        ]

        if has_admin?
          nav << {
            'href'  => '/admin/emails',
            'title' => 'E-Mails'
          }
          nav << {
            'href'  => '/admin/people',
            'title' => 'Fahrer'
          }
        end

        nav
      end

      def url; end

      def page
        @page
      end

      def page_count
        @count
      end

      def pagination?
        page_count
      end

      def pagination
        Array.new(page_count) do |i|
          if i+1 == page
            { title: i+1 }
          elsif i == 0
            { title: i+1, href:  url }
          else
            { title: i+1, href: "#{url}?page=#{i+1}" }
          end
        end
      end

      def pagination_left_right
        result = []
        # back
        if page == 1
          result << { title: '«' }
        elsif page == 2
          result << { title: '«', href: url }
        else
          result << { title: '«', href: "#{url}?page=#{page-1}" }
        end
        # forward
        if page == page_count
          result << { title: '»' }
        else
          result << { title: '»', href: "#{url}?page=#{page+1}" }
        end
        result
      end

    end
  end
end
