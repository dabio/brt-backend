module Brt
  module Views
    class Tidings < Layout

      def title
        'Nachrichten und Rennberichte'
      end

      def javascripts
        js :jquery, :underscore, :backbone, :main
      end

    end
  end
end
