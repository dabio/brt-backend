# encoding: UTF-8

module Brt
  class Frontend < Main

    set :mustache, {
      namespace: Brt,
      templates: "#{ROOT_DIR}/templates/frontend",
      views: "#{ROOT_DIR}/views/frontend"
    }

    #
    # GET /
    #
    get '/' do
      '/'
    end


    #
    # GET /news
    # Shows news. If no pagination parameter is provided, the latest 10 news are
    # shown.
    #
    get '/news' do
      '/news'
    end


    #
    # GET /news/:year/:month/:day/:slug
    # Shows the news based on the given year, month, day and slug parameters.
    #
    get '/news/:year/:month/:day/:slug' do
      '/news_detail'
    end


    #
    # GET /team
    # Shows a list of all team members.
    #
    get '/team' do
      '/team'
    end


    #
    # GET /team/:slug
    # Shows some detailed information about a cyclists.
    #
    get '/team/:slug' do
      '/team/slug'
    end


    #
    # GET /rennen
    # Shows an overview of all races in the current year.
    #
    get '/rennen' do
      '/rennen'
    end

    #
    # GET /rennen/[year]
    # Shows all events from a given year.
    #
    get '/rennen/:year' do |year|
      "/rennen/#{year}"
    end


    #
    # GET /rennen.ics
    # Returns all events of all time in an vcalendar formated format.
    #
    get '/rennen.ics' do
      #content_type 'text/calendar'
      'rennen_ics'
    end


    #
    # GET /rennen/:year/:month/:day/:slug
    # Redirects to a news if an report for the event exists. Otherwise the detail
    # site of the event is displayed.
    #
    get '/rennen/:year/:month/:day/:slug' do
      #redirect(to(@event.news.permalink), 301) if @event.news
      'rennen_detail'
    end


    #
    # GET /sponsoren
    # Shows a list of sponsors.
    #
    get '/sponsoren' do
      '/sponsoren'
    end

    #
    # GET /kontakt
    # Shows the contact form
    #
    get '/kontakt' do
      '/kontakt'
    end


    #
    # POST /kontakt
    # Checks if the users entered valid data in the form, saves the contact request
    # into the database and sends an email.
    #
    post '/kontakt' do
      # When email field is filled, we assume a robot submits this.
      redirect(to('/kontakt')) if params[:email].length > 0

      @email = Email.new(params[:contact])
      if @email.save
        flash[:notice] = "#{@email.name}, vielen Dank für deine Nachricht! Wir werden sie so schnell wie möglich beantworten."
        redirect to('/kontakt')
      end

      'kontakt'
    end


    #
    # Before filter to redirect all authenticated users to the main admin page.
    #
    before '/login' do
      redirect(to('/admin')) if has_auth?
    end


    #
    # GET /login
    #
    get '/login' do
      mustache :login
    end


    #
    # POST /login
    #
    post '/login' do
      halt mustache :login unless params[:email] and params[:password]

      email = params[:email].clone
      email << '@berlinracingteam.de' unless email['@']
      person = Person.authenticate(email, params[:password])

      if person
        session[:person_id] = person.id
        redirect to('/admin')
      else
        flash[:error] = 'Unbekannte E-Mail oder falsches Password eingegeben.'
        mustache :login, locals: {email: params[:email]}
      end
    end


    #
    # GET /logout
    #
    get '/logout' do
      not_found unless has_auth?

      session[:person_id] = nil
      redirect to('/')
    end


    #
    # GET /every/thing/else
    #
    not_found do
      halt mustache :not_found
    end

    #
    # PUT /visit
    # Everytime the user visits the site, it gets logged into the database.
    #
  #  put '/visit' do
  #    not_found unless has_auth?
  #    Visit.first_or_create(person: current_person).update(created_at: Time.now)
  #  end
  #
  #

  #
  #
  #
  #  get '/dashboard' do
  #    not_found unless has_auth?
  #
  #    @visits = Visit.all(order: [:updated_at.desc])
  #    #@participations = 
  #    @events = Event.all(:date.gte => today, order: [:date, :updated_at], limit: 3)
  #
  #    slim :dashboard
  #  end
  #
  #
  #  post '/reports/new' do
  #    not_found unless has_admin? and @event = Event.first(id: params[:event_id])
  #
  #    @report = Report.new params[:report]
  #    @report.date = today
  #    @report.event = @event
  #    @report.person = current_person
  #
  #    if @report.save
  #      redirect to(@event.permalink)
  #    end
  #
  #    slim :event
  #  end
  #
  #
  #  get '/diskussionen' do
  #    not_found unless @debates = Debate.all(order: [:updated_at.desc]) and has_auth?
  #
  #    slim :debates
  #  end
  #
  #
  #  get '/diskussionen/new' do
  #    not_found unless has_auth?
  #
  #    @debate = Debate.new
  #    @comment = Comment.new
  #
  #    slim :debate_form
  #  end
  #
  #
  #  post '/diskussionen/new' do
  #    not_found unless has_auth?
  #
  #    @debate = Debate.new params[:debate]
  #    @debate.person = current_person
  #
  #    @comment = Comment.new params[:comment]
  #    @comment.person = current_person
  #    @comment.debate = @debate
  #
  #    if @debate.valid? and @comment.valid?
  #      @debate.save
  #      @comment.save
  #
  #      flash[:notice] = 'Thema erfolgreich erstellt.'
  #      redirect to(@debate.permalink)
  #    end
  #
  #    slim :debate_form
  #  end
  #
  #
  #  get '/diskussionen/:id' do
  #    not_found unless @debate = Debate.first(id: params[:id]) and has_auth?
  #
  #    slim :debate
  #  end
  #
  #
  #
  #  post '/comments/new' do
  #    not_found unless has_auth?
  #
  #    @foreign_model = Kernel.const_get(params[:type]).first(id: params[:type_id])
  #    @comment = Comment.new(text: params[:text],
  #                           params[:type].downcase => @foreign_model,
  #                           person: current_person)
  #    if @comment.save
  #      @foreign_model.update updated_at: Time.now
  #      redirect to("#{@foreign_model.permalink}#comment_#{@comment.id}")
  #    end
  #
  #    redirect to(@foreign_model.permalink)
  #  end


    #get '/css/:stylesheet.css' do
    #  content_type 'text/css', charset: 'UTF-8'
    #  cache_control :public, max_age: 29030400
    #  scss :"css/#{params[:stylesheet]}"
    #end

  end
end
