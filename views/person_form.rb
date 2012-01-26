# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class App
  module Views
    class PersonForm < Layout

      def title
        if new?
          "Neuer Fahrer - Berlin Racing Team"
        else
          "Bearbeiten: #{@person.name} - Berlin Racing Team"
        end
      end

      def nav_team
        'active'
      end

      def new?
        @person.new?
      end

      def person
        return nil unless @person
        {
          first_name: @person.first_name,
          last_name: @person.last_name,
          email: @person.email,
          name: @person.name,
          errors: errors,
          save_link: new? ? @person.createlink : @person.editlink
        }
      end

      def errors?
        not errors.nil?
      end

      def errors
        return nil unless @person.errors.length > 0
        @person.errors.map do |e|
          {
            message: e[0]
          }
        end
      end

    end
  end
end

