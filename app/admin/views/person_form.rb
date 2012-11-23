module Brt
  module Views
    class PersonForm < AdminLayout

      def title
        if person.new?
          'Fahrer erstellen'
        else
          "Profil bearbeiten: #{person.name}"
        end
      end

      def person
        @person
      end

      def delete?
        !person.new? && has_auth?
      end

      def javascripts
        js :zepto, :admin
      end

    end
  end
end
