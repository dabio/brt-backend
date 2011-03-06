# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class Participation
  include DataMapper::Resource

  property :position_overall,   Integer
  property :position_age_class, Integer
  timestamps :at

  belongs_to :person,   :key => true
  belongs_to :event,    :key => true
end

