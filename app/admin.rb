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
        params[:news][:person] = current_person
        @news = News.create(params[:news])
        redirect(to('/news')) if @news.saved?
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

      redirect to(@news.editlink, true, false) if @news.update(params[:news])

      @events = Event.all_without_news
      mustache :tidings_form
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
        redirect(to('/events')) if @event.saved?
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
        participations = Participation.create(p)
      end

      redirect to(event.editlink, true, false)
    end

    #
    # Drivers are for admins only.
    #
#    before '/people*' do
#      not_found unless has_admin?
#    end

    #
    # GET /admin/people
    #
    get '/people' do
      people = Person.all(order: [:last_name.asc, :first_name.asc])
      mustache :people, locals: { people: people }
    end

    #
    # POST /admin/people
    # Shows the person create form and saves the person into the database.
    #
    post '/people' do
      @person = Person.new(params[:person])

#      if params[:news]
#        params[:news][:person] = current_person
#        @news = News.create(params[:news])
#        redirect(to('/news')) if @news.saved?
#      end

      mustache :person_form
    end

    #
    # PUT /admin/people/:id
    # Updates a person.
    #
    put '/people/:id' do |id|
      person = Person.get(id)

      if params[:person][:password].nil? or params[:person][:password].empty?
        params[:person].delete 'password'
        params[:person].delete 'password_confirmation'
      end

      person.update(params[:person])

      redirect to(person.editlink, true, false)
    end

    #
    # GET /admin/people/:id
    # Returns a single person form.
    #
    get '/people/:id' do |id|
      @person = Person.get(id)
      mustache :person_form
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
