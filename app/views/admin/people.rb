module Brt
  module Views
    class People < Layout

      def title
        'Fahrer'
      end

      def javascripts
        js :zepto, :underscore, :backbone, :main
      end

    end
  end
end
