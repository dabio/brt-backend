# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


class Visit
  include DataMapper::Resource

  property :id, Serial
  timestamps :at

  belongs_to :person
end
