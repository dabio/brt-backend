# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class App
  module Views
    class Kontakt < Layout

      def title
        'Kontakt - Berlin Racing Team'
      end

      def nav_kontakt
        'active'
      end

      def email
        @email
      end

      def errors?
        email.errors.length > 0
      end

      def errors
        email.errors.map do |e|
          {
            error: e[0]
          }
        end
      end

    end
  end
end
