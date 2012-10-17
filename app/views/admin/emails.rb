module Brt
  module Views
    class Emails < Layout

      def title
        'E-Mails'
      end

      def javascripts
        js :zepto, :underscore, :backbone, :main
      end

    end
  end
end
