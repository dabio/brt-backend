# encoding: utf-8

module Brt
  class App

    #
    # GET /
    #
    get '/' do
      redirect to('/login') unless has_auth?

      erb :index, locals: {
        items: Event.all(:date.gte => today, order: [:date.asc])
      }
    end


    before '/login' do
      redirect to('/') if has_auth?
    end

    #
    # GET /login
    #
    get '/login' do
      erb :login, locals: { email: '' }
    end

    #
    # POST /login
    #
    post '/login' do
      redirect to('/login') unless params[:email] and params[:password]

      email = params[:email].clone
      email << '@berlinracingteam.de' unless email['@']
      person = Person.authenticate(email, params[:password])

      if person
        session[:person_id] = person.id
        redirect to('/')
      else
        erb :login, locals: { email: params[:email] }
      end
    end

    #
    # GET /logout
    #
    get '/logout' do
      redirect to('/login') unless has_auth?

      session[:person_id] = nil
      redirect to('/login')
    end

    error do
      'Error'
    end

  end
end
