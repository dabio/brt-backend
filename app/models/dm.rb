# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

module DataMapper
  class Property

    autoload :BCryptHash, root_path('app/models/dm/bcrypt_hash')
    autoload :Enum,       root_path('app/models/dm/enum')
    autoload :URI,        root_path('app/models/dm/uri')

  end
end

