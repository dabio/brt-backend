module Brt
  module Views
    class News < Layout

      def title
        'Nachrichten und Rennberichte'
      end

      def javascripts
        js :jquery, :underscore, :backbone, :items
      end

    end
  end
end
