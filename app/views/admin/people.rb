module Brt
  module Views
    class People < Layout

      def title
        'Fahrer'
      end

      def javascripts
        js :jquery, :underscore, :backbone, :main
      end

    end
  end
end
