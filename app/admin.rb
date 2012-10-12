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
      mustache :index
    end


    #
    # GET /admin/news
    # GET /admin/news/:id
    #
    get '/news/?:id?' do
      mustache :tidings
    end


    #
    # GET /admin/events
    # GET /admin/events/:id
    #
    get '/events/?:id?' do
      mustache :events
    end


    #
    # GET /admin/people
    # GET /admin/people/:id
    #
    get '/people/?:id?' do
      not_found unless has_admin?
      mustache :people
    end


    #
    # GET /admin/emails
    # GET /admin/emails/:id
    #
    get '/emails/?:id?' do
      not_found unless has_admin?
      mustache :emails
    end

  end
end
