# encoding: utf-8

module Brt

  class Visit
    include DataMapper::Resource

    property :person_id, Integer, key: true
    timestamps :at

    belongs_to :person, key: true
  end

end
