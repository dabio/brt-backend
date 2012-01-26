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
  get '/news/:year/:month/:day/:slug' do
    @news = news
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
  get '/team/:slug' do
    @person = person
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
  # Redirects to a news if an report for the event exists. Otherwise the detail
  # site of the event is displayed.
  #
  get '/rennen/:year/:month/:day/:slug' do
    @event = event
    redirect(to(@event.news.permalink), 301) if @event.news
    mustache :event_detail
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
  # Before filter to redirect all authenticated users to the main admin page.
  #
  before '/login' do
    redirect(to('/admin')) if has_auth?
  end


  #
  # GET /login
  # Shows the login form.
  #
  get '/login' do
    mustache :login
  end


  #
  # POST /login
  # Checks the submitted data, sets a cookie and redirects to the admin area.
  #
  post '/login' do
    email = params[:email].clone
    email << '@berlinracingteam.de' unless email['@']
    person = Person.authenticate(email, params[:password])

    if person
      session[:person_id] = person.id
      redirect to('/admin')
    else
      flash.now[:error] = 'Unbekannte E-Mail oder falsches Password eingegeben.'
      mustache :login, locals: {email: params[:email]}
    end
  end

  #
  # GET /everythingelse
  # 404 Site with search and link to homepage
  #
  not_found do
    halt mustache :not_found
  end


  # FROM HERE ON EVERYTHING SHOULD BE IN A SEPERATE FILE CONTAINING ALL ADMIN
  # FUNCTIONS.

  #
  # Before filter to make sure the admin area is only accessible for
  # authenticated users.
  #
  before '/admin*' do
    not_found unless has_auth?
  end


  #
  # GET /admin/logout
  # Checks if the user is authenticated, deletes the session and redirects to
  # the homepage.
  #
  get '/admin/logout' do
    session[:person_id] = nil
    redirect to('/')
  end


  #
  # GET /admin/news/new
  # Creates a new news instance.
  #
  get '/admin/news/new' do
    @news = News.new()
    @events = Event.all_without_news
    mustache :news_form
  end


  #
  # POST /admin/news/new
  # Creates a new news instance.
  #
  post '/admin/news/new' do
    params[:news][:person] = current_person
    @news = News.create(params[:news])
    @events = Event.all_without_news
    params[:news][:event_id] = nil unless params[:news][:event_id].length > 0
    redirect(to(@news.permalink)) if @news.saved?
    mustache :news_form
  end


  #
  # GET /admin/news/[year]/[month]/[day]/[slug]/edit
  # Shows the edit form for an existing news item.
  #
  get '/admin/news/:year/:month/:day/:slug' do
    @events = Event.all_without_news
    @news = news
    mustache :news_form
  end


  #
  # PUT /admin/news/[year]/[month]/[day]/[slug]
  # Updates an already existing news item.
  #
  post '/admin/news/:year/:month/:day/:slug' do |year, month, day, slug|
    params[:news][:event_id] = nil unless params[:news][:event_id].length > 0
    redirect(to(news.permalink)) if news.update(params[:news])
    @events = Event.all_without_news
    mustache :news_form
  end


  #
  # GET /admin/team/new
  # Shows a form that allows the creation of a new team member.
  #
  get '/admin/team/new' do
    @person = Person.new()
    mustache :person_form
  end


  #
  # POST /admin/team/new
  # Creates a new person instance.
  #
  post '/admin/team/new' do

    if params[:person][:password].nil? or params[:person][:password].empty?
      params[:person].delete "password"
      params[:person].delete "password_confirmation"
    end

    @person = Person.create(params[:person])
    redirect(to(@person.permalink)) if @person.saved?
    mustache :person_form
  end


  #
  # GET /admin/team/[slug]
  # Shows th eedit form for an individual user.
  #
  get '/admin/team/:slug' do
    @person = person
    mustache :person_form
  end


  #
  # POST /admin/team/[slug]
  # Updates an already existing user.
  #
  post '/admin/team/:slug' do

    if params[:person][:password].nil? or params[:person][:password].empty?
      params[:person].delete "password"
      params[:person].delete "password_confirmation"
    end

    redirect(to(person.permalink)) if person.update(params[:person])
    mustache :person_form
  end

  #
  # DELETE /admin/team/[slug]
  # Deletes a user.
  #
  delete '/admin/team/:slug' do

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

  run! if app_file == $0

end

