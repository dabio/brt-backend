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
      events = Event.all(order: [:date.desc])
      mustache :events, locals: { events: events }
    end

    #
    # GET /admin/events/:id
    # Returns a single event.
    #
    get '/events/:id' do |id|
      event = Event.get(id)
      mustache :event_form, locals: { event: event }
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
