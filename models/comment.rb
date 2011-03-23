# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class Comment
  include DataMapper::Resource

  property :id,     Serial
  property :text,   Text
  timestamps :at

  belongs_to :person
  belongs_to :debate, :required => false
  belongs_to :news,   :required => false
  belongs_to :event,  :required => false
  

  validates_presence_of :text

  def permalink
    "/diskussion/#{debate.id}/##{id}"
  end
end

