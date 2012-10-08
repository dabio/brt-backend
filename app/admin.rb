module Brt
  class Admin

    #
    # Disallow the admin area for non authorized users.
    #
    before do
      not_found unless has_auth?
    end


    #
    # GET /admin
    #
    get '/' do
      '/'
    end


    #
    # GET /admin/news
    #
    get '/news' do
      '/news'
    end


    #
    # GET /admin/events
    #
    get '/events' do
      '/events'
    end


    #
    # GET /admin/persons
    #
    get '/persons' do
      not_found unless has_admin?
      '/persons'
    end


    #
    # GET /admin/emails
    #
    get '/emails' do
      not_found unless has_admin?
      '/emails'
    end

  end
end
