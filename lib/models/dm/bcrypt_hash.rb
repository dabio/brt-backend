# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

module DataMapper
  class Property
    class BCryptHash < String
      length 60

      def primitive?(value)
        value.kind_of?(BCrypt::Password)
      end

      def load(value)
        if value.nil?
          nil
        else
          begin
            primitive?(value) ? value : BCrypt::Password.new(value)
          rescue BCrypt::Errors::InvalidHash
            BCrypt::Password.create(value, :cost => BCrypt::Engine::DEFAULT_COST)
          end
        end
      end

      def dump(value)
        load(value)
      end

      def typecast_to_primitive(value)
        load(value)
      end
    end # class BCryptHash
  end # class Property
end # module DataMapper

