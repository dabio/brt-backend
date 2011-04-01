# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

module DataMapper
  class Property

    autoload :BCryptHash,         './app/helpers/dm/bcrypt_hash'
    autoload :Enum,               './app/helpers/dm/enum'
    autoload :URI,                './app/helpers/dm/uri'

  end
end

