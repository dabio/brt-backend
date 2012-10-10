module Brt
  module Views
    class Events < Layout

      def title
        'Rennen'
      end

      def javascripts
        js :jquery, :underscore, :backbone, :items
      end

    end
  end
end
