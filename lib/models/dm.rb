# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

module DataMapper
  class Property
    autoload :BCryptHash,   './lib/models/dm/bcrypt_hash'
    autoload :URI,          './lib/models/dm/uri'
  end
end

