# encoding: utf-8

module Brt
  module Views
    class SponsorForm < AdminLayout

      def title
        if sponsor.new?
          'Sponsor erstellen'
        else
          "Sponsor bearbeiten: #{Sponsor.title}"
        end
      end

      def sponsor
        @sponsor
      end

      def delete?
        !sponsor.new? && has_admin?
      end


      def javascripts
        js :zepto, :admin
      end

    end
  end
end

