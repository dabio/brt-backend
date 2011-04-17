# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


require 'bundler'
Bundler.require

RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined? RACK_ENV
ROOT_DIR = File.dirname(__FILE__) unless defined? ROOT_DIR

# Helper method for file references.
#
# @params args [Array] Path components relative to ROOT_DIR.
# @example Referencing a file in config called settings.yml:
#   root_path('config', 'settings.xml')
def root_path(*args)
  File.join(ROOT_DIR, *args)
end

# Sinatra::Base. This way, we're not polluting the global namespace with your
# methods and routes and such.
class BerlinRacingTeam < Sinatra::Base; end

class BerlinRacingTeam
  set :method_override, true
  set :root, root_path
  set :default_locale, 'de'

  set :cdn, '//berlinracingteam.commondatastorage.googleapis.com'

  register Sinatra::Flash
  register Sinatra::R18n

  use Rack::ForceDomain, ENV['DOMAIN']
  use Rack::Session::Cookie
  # We're using rack-timeout to ensure that our dynos don't get starved by
  # renegade processes.
  use Rack::Timeout
  Rack::Timeout.timeout = 10

  configure :development, :test do
    begin
      require 'ruby-debug'
    rescue LoadError
    end
  end

  helpers do
    [:development, :production, :test].each do |environment|
      define_method "#{environment.to_s}?" do
        return settings.environment == environment.to_sym
      end
    end
  end

  DataMapper::Logger.new($stdout, :debug) if development?
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db/local.db?encoding=utf8')


  head '/' do; end


  get '/' do
    @news = News.all(:date.lte => today, :order => [:date.desc, :updated_at.desc],
                     :limit => 3)
    slim :index
  end


  get '/dashboard' do
    not_found unless has_auth?

    @visits = Visit.all(order: [:updated_at.desc])
    slim :dashboard
  end


  get '/login' do
    redirect to('/') if has_auth?
    slim :login
  end


  post '/login' do
    params[:email] << '@berlinracingteam.de' unless params[:email]['@']
    @person = Person.authenticate(params[:email], params[:password])

    if @person
      session[:person_id] = @person.id
      redirect to('/dashboard')
    else
      flash.now[:error] = 'Unbekannte E-Mail oder falsches Password eingegeben.'
      slim :login
    end
  end


  get '/logout' do
    not_found unless has_auth?
    session[:person_id] = nil
    redirect to('/')
  end


  get '/team' do
    @people = Person.all :order => [:last_name, :first_name]
    slim :people
  end


  get '/team/:slug' do
    not_found unless @person = Person.first(slug: params[:slug])
    slim :person
  end


  get '/team/:slug/edit' do
    not_found unless @person = Person.first(slug: params[:slug])
    not_found unless @person == current_person or has_admin?

    slim :person_form
  end


  put '/team/:slug/edit'do
    not_found unless @person = Person.first(slug: params[:slug])
    not_found unless @person == current_person or has_admin?

    @person.attributes = {
      :email  => params[:person]['email'],
      :info   => params[:person]['info']
    }

    unless params[:person]['password'].nil? or params[:person]['password'].empty?
      @person.password = params[:person]['password']
      @person.password_confirmation = params[:person]['password_confirmation']
    end

    if @person.save
      flash[:notice] = 'Änderung gespeichert.'
      redirect to(@person.editlink)
    end

    slim :person_form
  end


  get '/rennen' do
    @events = Event.all(:date.gte => "#{today.year}-01-01",
                        :date.lte => "#{today.year}-12-31",
                        order: [:date, :updated_at.desc])
    slim :events
  end


  get '/rennen/:y/:m/:d/:slug/edit' do
    date = Date.new params[:y].to_i, params[:m].to_i, params[:d].to_i
    not_found unless @event = Event.first(date: date, slug: params[:slug])
    not_found unless has_auth?

    slim :event_form
  end


  put '/rennen/:y/:m/:d/:slug/edit' do
    date = Date.new params[:y].to_i, params[:m].to_i, params[:d].to_i
    not_found unless @event = Event.first(date: date, slug: params[:slug])
    not_found unless has_auth?

    if @event.update(params[:event])
      flash[:notice] = 'Deine Änderungen wurden gesichert'
      redirect to(@event.editlink)
    end

    slim :event_form
  end


  get '/rennen/new' do
    not_found unless has_auth?
    @event = Event.new
    slim :event_form
  end


  post '/rennen/new' do
    not_found unless has_auth?

    @event = Event.new(params[:event])
    @event.person = current_person

    if @event.save
      flash[:notice] = 'Rennen erstellt'
      redirect to('/rennen')
    end

    slim :event_form
  end


  get '/rennen/:year' do
    @events = Event.all(:date.gte => "#{params[:year]}-01-01",
                        :date.lte => "#{params[:year]}-12-31",
                        order: [:date, :updated_at.desc])
    slim :events
  end


  get '/diskussionen' do
    not_found unless @debates = Debate.all(order: [:updated_at.desc]) and has_auth?

    slim :debates
  end


  get '/diskussionen/new' do
    not_found unless has_auth?

    @debate = Debate.new
    @comment = Comment.new

    slim :debate_form
  end


  post '/diskussionen/new' do
    not_found unless has_auth?

    @debate = Debate.new params[:debate]
    @debate.person = current_person

    @comment = Comment.new params[:comment]
    @comment.person = current_person
    @comment.debate = @debate

    if @debate.valid? and @comment.valid?
      @debate.save
      @comment.save

      flash[:notice] = 'Thema erfolgreich erstellt.'
      redirect to(@debate.permalink)
    end

    slim :debate_form
  end


  get '/diskussionen/:id' do
    not_found unless @debate = Debate.first(id: params[:id]) and has_auth?

    slim :debate
  end


  put '/visit' do
    not_found unless has_auth?
    Visit.first_or_create(person: current_person).update(created_at: Time.now)
  end


  get '/sponsoren' do
    slim :sponsoren
  end


  get '/kontakt' do
    @email = Email.new()
    slim :kontakt
  end


  post '/kontakt' do
    raise not_found unless params[:email].length == 0

    @email = Email.new params[:contact]
    if @email.valid?
      @email.send_at = Time.now
      @email.save
      @email.send_email(ENV['CONTACT_EMAIL']) if production?
      flash[:notice] = "#{@email.name}, vielen Dank für deine Nachricht! Wir werden sie so schnell wie möglich beantworten."

      redirect to('/kontakt')
    else
      slim :kontakt
    end
  end


  post '/comments/new' do
    not_found unless has_auth?

    @foreign_model = Kernel.const_get(params[:type]).first(id: params[:type_id])
    @comment = Comment.new(text: params[:text],
                           params[:type].downcase => @foreign_model,
                           person: current_person)
    if @comment.save
      @foreign_model.update updated_at: Time.now
      redirect to("#{@foreign_model.permalink}#comment_#{@comment.id}")
    end

    redirect to(@foreign_model.permalink)
  end


  get '/css/:stylesheet.css' do
    content_type 'text/css', charset: 'UTF-8'
    cache_control :public, max_age: 29030400
    scss :"css/#{params[:stylesheet]}"
  end


  not_found do
    slim :'404'
  end

end


# helpers
require(root_path('helpers.rb'))

# models
Dir[root_path('models/*.rb')].each do |file|
  require(file)
end

