module Brt
  module Views
    class Layout < Mustache

      def title
        'Berlin Racing Team'
      end

      def path_to(script)
        case script
        when :jquery then '//cdnjs.cloudflare.com/ajax/libs/jquery/1.8.2/jquery.min.js'
        when :underscore then '//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.1/underscore-min.js'
        #when :backbone then '//cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.2/backbone-min.js'
        else "/js/#{script}.js"
        end
      end

      def js(*args)
        js = args
        js.flatten.uniq.map do |script|
          "<script defer src=#{path_to script}></script>"
        end.join
      end

      def javascripts; end

      def production?
        RACK_ENV == 'production'
      end

      def development?
        RACK_ENV == 'development'
      end

    end
  end
end
