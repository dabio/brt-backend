# encoding: utf-8

class Sponsor < Base
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String, length: 50, required: true
  property :text,       Text
  property :image_url,  URI, required: true
  property :url,        URI
  timestamps :at

  default_scope(:default).update(order: [:title])

  def self.link
    '/sponsors'
  end

end
