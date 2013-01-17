# encoding: utf-8

module Brt

  class Debate
    include DataMapper::Resource

    property :id,     Serial
    property :title,  String, required: true
    timestamps :at

    belongs_to :person
    has n, :comments

    validates_presence_of :title

    def editlink
      "/admin/debates/#{id}"
    end

  end

end
