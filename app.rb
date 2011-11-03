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
  set :views, "#{settings.root}/app/views"

  set :cdn, '//berlinracingteam.commondatastorage.googleapis.com'

  register Sinatra::Flash
  register Sinatra::R18n

  use Rack::ForceDomain, ENV['DOMAIN']
  use Rack::Session::Cookie
  # We're using rack-timeout to ensure that our dynos don't get starved by
  # renegade processes.
  use Rack::Timeout
  Rack::Timeout.timeout = 10
  use Rack::Protection

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
    @news = News.all(:date.lte => today, order: [:date.desc, :updated_at.desc],
                     limit: 6)
    slim :index
  end


  get '/dashboard' do
    not_found unless has_auth?

    @visits = Visit.all(order: [:updated_at.desc])
    #@participations = 
    @events = Event.all(:date.gte => today, order: [:date, :updated_at], limit: 3)

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


  post '/reports/new' do
    not_found unless has_admin? and @event = Event.first(id: params[:event_id])

    @report = Report.new params[:report]
    @report.date = today
    @report.event = @event
    @report.person = current_person

    if @report.save
      redirect to(@event.permalink)
    end

    slim :event
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
    if @email.save
      flash[:notice] = "#{@email.name}, vielen Dank für deine Nachricht! Wir werden sie so schnell wie möglich beantworten."

      redirect to('/kontakt')
    end

    slim :kontakt
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

# controllers
Dir[root_path('app/controllers/*_controller.rb')].each do |file|
  require(file)
end

# helpers
require(root_path('helpers.rb'))

# models
Dir[root_path('app/models/*.rb')].each do |file|
  require(file)
end

