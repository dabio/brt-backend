module Brt
  class Api

    #
    # Disallow the api for non authorized users.
    #
    before do
      not_found unless has_auth?
    end


    # NEWS

    #
    # GET /api/news
    # Shows a list of all news.
    #
    get '/news', :provides => 'json' do
      News
        .all(order: [:date.desc])
        .to_json(only: [:id, :date, :title, :teaser])
    end


    #
    # GET /api/news/:id
    # Returns a single news entry.
    #
    get '/news/:id', :provides => 'json' do |id|
      Event
        .get(id)
        .to_json(only: [:id, :date, :title, :teaser, :message, :slug])
    end


    #
    # POST /api/news
    # Creates a news.
    #
    post '/news', :provides => 'json' do
      puts 'post'
    end


    #
    # PUT /api/news/:id
    # Updates a given news.
    #
    put '/news/:id', :provides => 'json' do |id|
      puts 'put'
    end


    #
    # DELETE /api/news/:id
    # Deletes a news.
    #
    delete '/news/:id', :provides => 'json' do |id|
      News.get(id).destroy
    end


    # EVENT

    #
    # GET /api/events
    # Shows a list of all events.
    #
    get '/events', :provides => 'json' do
      Event
        .all(order: [:date.desc])
        .to_json(only: [:id, :date, :title])
    end


    #
    # GET /api/events/:id
    # Returns a single event.
    #
    get '/events/:id', :provides => 'json' do |id|
      Event
        .get(id)
        .to_json(only: [:id, :date, :url, :title, :distance])
    end


    #
    # POST /api/events
    # Creates a new event.
    #
    post '/events', :provides => 'json' do
      puts 'post'
    end


    #
    # PUT /api/events/:id
    # Updates a given event.
    #
    put '/events/:id', :provides => 'json' do |id|
      puts 'put'
    end


    #
    # DELETE /api/events/:id
    # Deletes a event.
    #
    delete '/events/:id', :provides => 'json' do |id|
      Event.get(id).destroy
    end


    # VISITS

    #
    # GET /api/visits
    # Shows a list of all visits.
    #
    get '/visits', :provides => 'json' do
      puts 'get'
    end


    #
    # PUT /api/visits/:id
    # Updates a given visit.
    #
    put '/visits/:id', :provides => 'json' do |id|
      puts 'put'
    end


    # EMAILS

    #
    # DELETE /api/emails/:id
    # Deletes an email.
    #
    delete '/emails/:id', :provides => 'json' do |id|
      Email.get(id).destroy
    end


    # PEOPLE

    #
    # Disallow the people api for non admin users.
    #
    before '/people*' do
      not_found unless has_admin?
    end


    #
    # GET /api/people
    # Shows a list of all people.
    #
    get '/people', :provides => 'json' do
      Person
        .all(order: [:last_name.desc, :first_name.desc])
        .to_json(only: [:id, :email], methods: [:name])
    end


    #
    # GET /api/people/:id
    # Gets a single person.
    #
    get '/people/:id', :provides => 'json' do |id|
      Person
        .get(id)
        .to_json(only: [:first_name, :last_name, :email])
    end

    #
    # POST /api/people
    # Creates a new people.
    #
    post '/people', :provides => 'json' do
      puts 'post'
    end


    #
    # PUT /api/people/:id
    # Updates a given people.
    #
    put '/people/:id', :provides => 'json' do |id|
      puts 'put'
    end


    #
    # DELETE /api/people/:id
    # Deletes a people.
    #
    delete '/people/:id', :provides => 'json' do |id|
      Person.get(id).detroy
    end

  end
end
