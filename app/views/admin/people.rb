module Brt
  module Views
    class People < Layout

      def title
        'Fahrer'
      end

      def javascripts
        js :jquery, :underscore, :backbone, :items
      end

    end
  end
end
