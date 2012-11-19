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

    end
  end
end
