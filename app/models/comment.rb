# encoding: utf-8

class Comment < Base
  include DataMapper::Resource

  property :id,         Serial
  property :text,   Text
  timestamps :at

  belongs_to :person
  belongs_to :debate, required: false
  belongs_to :news,   required: false
  belongs_to :event,  required: false

  validates_presence_of :text

  def permalink
    "/diskussion/#{debate.id}/##{id}"
  end
end
