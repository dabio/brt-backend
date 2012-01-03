# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

# Sinatra::Base. This way, we're not polluting the global namespace with your
# methods and routes and such.
class App

  # for wasitup
  head '/' do; end


  #
  # GET /
  # Shows the team image and the last 6 news items.
  #
  get '/' do
    @news = News.all(:date.lte => today, limit: 6)
    mustache :index
  end


  #
  # GET /news
  # Shows news. If no pagination parameter is provided, the latest 10 news are
  # shown.
  #
  get '/news' do
    @count, @news = News.paginated(
      page: current_page, per_page: 10, :date.lte => today
    )
    not_found unless @news.length > 1
    @page = current_page
    mustache :news_list
  end


  #
  # GET /news/[year]/[month]/[day]/[slug]
  # Shows the news based on the given year, month, day and slug parameters.
  #
  get '/news/:y/:m/:d/:slug' do |year, month, day, slug|
    date = Date.new(year.to_i, month.to_i, day.to_i)
    not_found unless @news = News.first(date: date, slug: slug)
    mustache :news_detail
  end


  #
  # GET /team
  # Shows a list of all team members.
  #
  get '/team' do
    @people = Person.all
    mustache :people_list
  end


  #
  # GET /team/[slug]
  # Shows some detailed information about a cyclists.
  #
  get '/team/:slug' do |slug|
    not_found unless @person = Person.first(slug: slug)
    mustache :person_detail
  end


  #
  # GET /rennen
  # Shows an overview of all races in the current year.
  #
  get '/rennen' do
    @events = Event.all_for_year(Date.today.year)
    not_found unless @events.length > 0
    mustache :events_list
  end


  #
  # GET /rennen/[year]
  # Shows all events from a given year.
  #
  get '/rennen/:year' do |year|
    @events = Event.all_for_year(year)
    not_found unless @events.length > 0
    mustache :events_list
  end


  #
  # GET /rennen.ics
  # Returns all events of all time in an vcalendar formated format.
  #
  get '/rennen.ics' do
    @events = Event.all
    content_type 'text/calendar'
    mustache :events_ics, layout: false
  end


  #
  # GET /rennen/[year]/[month]/[day]/[slug]
  # Shows a single event from a given year, month, day and slug parameter.
  get '/rennen/:y/:m/:d/:slug' do |year, month, day, slug|
    date = Date.new(year.to_i, month.to_i, day.to_i)
    not_found unless @event = Event.first(date: date, slug: slug)
    slim :event
  end


  #
  # GET /sponsoren
  # Shows a list of sponsors.
  #
  get '/sponsoren' do
    mustache :sponsoren
  end


  #
  # GET /kontakt
  # Shows the contact form
  #
  get '/kontakt' do
    @email = Email.new()
    mustache :kontakt
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
      flash[:notice] = "#{@email.name}, vielen Dank für deine Nachricht!"
      flash[:notice] << " Wir werden sie so schnell wie möglich beantworten."
      redirect to('/kontakt')
    end

    mustache :kontakt
  end

  #
  # GET /everythingelse
  # 404 Site with search and link to homepage
  #
  not_found do
    mustache :not_found
  end


  # FROM HERE ON EVERYTHING SHOULD BE IN A SEPERATE FILE CONTAINING ALL ADMIN
  # FUNCTIONS.

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
#  #
#  # GET /login
#  # Shows the login form.
#  #
#  get '/login' do
#    slim :login
#  end
#
#
#  #
#  # POST /login
#  # Checks the submitted data, sets a cookie and redirects to the admin area.
#  #
#  post '/login' do
#    params[:email] << '@berlinracingteam.de' unless params[:email]['@']
#    @person = Person.authenticate(params[:email], params[:password])
#
#    if @person
#      session[:person_id] = @person.id
#      redirect to('/dashboard')
#    else
#      flash.now[:error] = 'Unbekannte E-Mail oder falsches Password eingegeben.'
#      slim :login
#    end
#  end
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
#
#  get '/logout' do
#    not_found unless has_auth?
#    session[:person_id] = nil
#    redirect to('/')
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

