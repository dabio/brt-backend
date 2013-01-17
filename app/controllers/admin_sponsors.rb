# encoding: utf-8

module Brt
  class AdminSponsors < Main

    #
    # Disallow the admin area for non authorized users.
    #
    before do
      not_found unless has_admin?
    end

    #
    # GET /admin/sponsors
    #
    get '/' do
      @sponsors = Sponsor.all
      slim :index
    end

  end
end


__END__

/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ layout
doctype html
html
  head
    title Hell yea
  body
    h1 Sinatra + MongoDB through Mongoid
    == yield


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ index
p lalala
