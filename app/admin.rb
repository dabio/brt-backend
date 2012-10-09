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
      '/admin'
    end


    #
    # GET /admin/news
    #
    get '/news' do
      '/admin/news'
    end


    #
    # GET /admin/events
    #
    get '/events' do
      '/admin/events'
    end


    #
    # GET /admin/people
    #
    get '/people' do
      not_found unless has_admin?
      '/admin/people'
    end


    #
    # GET /admin/emails
    #
    get '/emails' do
      not_found unless has_admin?
      '/admin/emails'
    end

  end
end
