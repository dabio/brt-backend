# encoding: utf-8
module Brt
  module Views
    class Layout < Mustache

      def title
        @title || 'Berlin Racing Team'
      end

      def flash
        @flash
      end

    end
  end
end
