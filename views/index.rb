# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class App
  module Views
    class Index < Layout

      def nav_home
        "active"
      end

      def news
        @news.each_index { |i| @news[i].index = i }
        @news
      end

    end
  end
end
