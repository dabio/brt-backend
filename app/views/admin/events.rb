module Brt
  module Views
    class Events < Layout

      def title
        'Rennen'
      end

      def javascripts
        js :jquery, :underscore, :backbone, :main
      end

    end
  end
end
