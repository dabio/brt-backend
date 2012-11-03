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
      news = News.all(order: [:date.desc])
      mustache :tidings, locals: { news: news }
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
    # GET /admin/events
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
    before '/people*' do
      not_found unless has_admin?
    end

    #
    # GET /admin/people
    #
    get '/people' do
      people = Person.all(order: [:last_name.asc, :first_name.asc])
      mustache :people, locals: { people: people }
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
      emails = Email.all(order: [:send_at.desc])
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
