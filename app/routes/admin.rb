# encoding: utf-8

module Brt
  class Admin

    #
    # Disallow the admin area for non authorized users.
    #
    before do
      not_found unless has_auth?
    end


    #
    # Track every visit.
    #
    after do
      Visit.first_or_create(person: current_person).update(created_at: Time.now)
    end


    #
    # GET /admin
    #
    get '/' do
      @events = Event.all(:date.gte => today)
      mustache :index
    end


    #
    # GET /admin/news
    #
    get '/news' do
      @page = current_page
      @count, news = News.paginated(
        page: @page, per_page: 20, order: :date.desc
      )
      mustache :tidings, locals: { news: news }
    end

    #
    # POST /admin/news
    # Shows the news create form and saves the news into the database.
    #
    post '/news' do
      @news = News.new(params[:news])

      if params[:news]
        params[:news][:event_id] = nil unless params[:news][:event_id].length > 0
        params[:news][:person] = current_person
        @news = News.create(params[:news])

        if @news.saved?
          if params[:news][:event_id]
            flash[:success] = 'Rennbericht erfolgreich angelegt'
          else
            flash[:success] = 'News erfolgreich angelegt'
          end

          redirect(to('/news'))
        end
      end

      @events = Event.all_without_news

      mustache :tidings_form
    end

    #
    # GET /admin/news/:id
    # Returns a single news.
    #
    get '/news/:id' do |id|
      @news = News.get(id)
      @events = Event.all_without_news

      mustache :tidings_form
    end

    #
    # PUT /admin/news/:id
    # Updates the news.
    #
    put '/news/:id' do |id|
      @news = News.get(id)
      params[:news][:event_id] = nil unless params[:news][:event_id].length > 0

      if @news.update(params[:news])
        if params[:news][:event_id]
          flash[:success] = 'Rennbericht erfolgreich gespeichert'
        else
          flash[:success] = 'News erfolgreich gespeichert'
        end

        redirect to(@news.editlink, true, false)
      end

      @events = Event.all_without_news
      mustache :tidings_form
    end

    #
    # DELETE /admin/news/:id
    # Deletes a news.
    #
    delete '/news/:id' do |id|
      not_found unless news = News.get(id)
      if news.destroy
        flash[:success] = 'Erfolgreich gelöscht'
        to('/news')
      else
        to(news.editlink)
      end
    end


    #
    # GET /admin/events
    #
    get '/events' do
      @page = current_page
      @count, events = Event.paginated(
        page: @page, per_page: 20, order: :date.desc
      )
      mustache :events, locals: { events: events }
    end

    #
    # POST /admin/events
    # Shows the event create form and saves the event in the database.
    #
    post '/events' do
      @event = Event.new(params[:event])

      if params[:event]
        params[:event][:person] = current_person
        @event = Event.create(params[:event])

        if @event.saved?
          flash[:success] = 'Rennen erfolgreich erstellt'
          redirect(to('/events'))
        end
      end

      mustache :event_form
    end

    #
    # GET /admin/events/:id
    # Returns a single event.
    #
    get '/events/:id' do |id|
      @event = Event.get(id)
      mustache :event_form
    end

    #
    # PUT /admin/events/:id
    # Updates the event
    #
    put '/events/:id' do |id|
      # Update the event.
      event = Event.get(id)
      event.update(params[:event])
      # Destroy all previous participations.
      Participation.all(event: event).destroy
      # Create a new entry for each participation.
      params[:p].each_value do |p|
        next unless p.include?('person_id')
        p = p.reject { |key, value| value.empty? }.merge({ event_id: id })
        Participation.create(p)
      end

      flash[:success] = 'Rennen gesichert'
      redirect to(event.editlink, true, false)
    end

    #
    # DELETE /admin/events/:id
    # Deletes an event.
    #
    delete '/events/:id' do |id|
      not_found unless event = Event.get(id)
      if event.destroy
        flash[:success] = 'Rennen erfolgreich gelöscht'
        to('/events')
      else
        to(event.editlink)
      end
    end


    #
    # POST /admin/participations
    # Creates a new participation. Needs an event id and a person id as post
    # parameters.
    #
    post '/participations', :provides => :json do
      Participation.first_or_create(params)
        .to_json(
          methods: [:deletelink],
          only: [:id],
          relationships: {
            person: { methods: [:name], only: [:id] },
            event: { only: [:id] }
          }
        )
    end

    #
    # DELETE /admin/participations/:id
    # Removes a participation.
    #
    delete '/participations/:id', :provides => :json do |id|
      p = Participation.get(id)
      event_id = p.event.id
      p.destroy
      {
        url: Participation.createlink,
        person: { id: current_person.id },
        event: { id: event_id }
      }.to_json
    end


    #
    # GET /admin/people
    #
    get '/people' do
      not_found unless has_admin?
      people = Person.all(order: [:last_name.asc, :first_name.asc])
      mustache :people, locals: { people: people }
    end

    #
    # POST /admin/people
    # Shows the person create form and saves the person into the database.
    #
    post '/people' do
      not_found unless has_admin?
      @person = Person.new(params[:person])

      if params[:person]
        @person = Person.create(params[:person])

        if @person.saved?
          flash[:success] = 'Neuen Fahrer erfolgreich angelegt'
          redirect(to('/people'))
        end
      end

      mustache :person_form
    end

    #
    # GET /admin/people/:id
    # Returns a single person form.
    #
    get '/people/:id' do |id|
      allowed = has_admin? || current_person.id == id.to_i
      not_found unless allowed

      @person = Person.get(id)
      mustache :person_form
    end

    #
    # PUT /admin/people/:id
    # Updates a person.
    #
    put '/people/:id' do |id|
      allowed = has_admin? || current_person.id == id.to_i
      not_found unless allowed

      person = Person.get(id)

      if params[:person][:password].nil? or params[:person][:password].empty?
        params[:person].delete 'password'
        params[:person].delete 'password_confirmation'
      end

      params[:person][:is_admin] = !params[:person][:is_admin].nil?

      flash[:success] = 'Einstellungen gespeichert'
      person.update(params[:person])

      redirect to(person.editlink, true, false)
    end

    #
    # DELETE /admin/people/:id
    # Deletes a person.
    #
    delete '/people/:id' do |id|
      not_found unless has_admin? && person = Person.get(id)
      if person.destroy
        flash[:success] = 'Person erfolgreich gelöscht'
        to('/people')
      else
        to(person.editlink)
      end
    end


    #
    # Emails are for admins only.
    #
    before '/emails*' do
      not_found unless has_admin?
    end

    #
    # GET /admin/emails
    # Return a list of all emails.
    #
    get '/emails' do
      @page = current_page
      @count, emails = Email.paginated(
        page: @page, per_page: 20, order: :send_at.desc
      )
      mustache :emails, locals: { emails: emails }
    end

    #
    # GET /admin/emails/:id
    # Returns a single email.
    #
    get '/emails/:id' do |id|
      email = Email.get(id)
      mustache :email_form, locals: { email: email }
    end

  end
end
