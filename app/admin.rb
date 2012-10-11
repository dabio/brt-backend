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
    #
    get '/news' do
      mustache :tidings
    end


    #
    # GET /admin/events
    #
    get '/events' do
      mustache :events
    end


    #
    # GET /admin/people
    #
    get '/people' do
      not_found unless has_admin?
      mustache :people
    end


    #
    # GET /admin/emails
    #
    get '/emails' do
      not_found unless has_admin?
      mustache :emails
    end

  end
end
