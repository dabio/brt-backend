# encoding: utf-8

module Brt

  class Sponsor
    include DataMapper::Resource

    property :id,         Serial
    property :title,      String, length: 50
    property :text,       Text
    property :image_url,  URI
    timestamps :at

    default_scope(:default).update(order: [:title])

    def editlink
      "/admin/sponsors/#{id}"
    end

  end

end
