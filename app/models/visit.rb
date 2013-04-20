# encoding: utf-8

class Visit
  include DataMapper::Resource

  property :person_id, Integer, key: true
  timestamps :at

  belongs_to :person, key: true
end
