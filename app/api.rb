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
      puts 'get'
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
      puts 'delete'
    end


    # EVENT

    #
    # GET /api/event
    # Shows a list of all events.
    #
    get '/event', :provides => 'json' do
      puts 'get'
    end


    #
    # POST /api/event
    # Creates a new event.
    #
    post '/event', :provides => 'json' do
      puts 'post'
    end


    #
    # PUT /api/event/:id
    # Updates a given event.
    #
    put '/event/:id', :provides => 'json' do |id|
      puts 'put'
    end


    #
    # DELETE /api/event/:id
    # Deletes a event.
    #
    delete '/event/:id', :provides => 'json' do |id|
      puts 'delete'
    end


    # PERSON

    #
    # Disallow the person api for non admin users.
    #
    before '/person*' do
      not_found unless has_admin?
    end


    #
    # GET /api/person
    # Shows a list of all persons.
    #
    get '/person', :provides => 'json' do
      puts 'get'
    end


    #
    # POST /api/person
    # Creates a new person.
    #
    post '/person', :provides => 'json' do
      puts 'post'
    end


    #
    # PUT /api/person/:id
    # Updates a given person.
    #
    put '/person/:id', :provides => 'json' do |id|
      puts 'put'
    end


    #
    # DELETE /api/person/:id
    # Deletes a person.
    #
    delete '/person/:id', :provides => 'json' do |id|
      puts 'delete'
    end


  end
end
