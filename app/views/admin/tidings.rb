module Brt
  module Views
    class Tidings < Layout

      def title
        'Nachrichten und Rennberichte'
      end

      def javascripts
        js :zepto, :underscore, :backbone, :main
      end

    end
  end
end
