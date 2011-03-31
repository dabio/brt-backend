# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class BerlinRacingTeam

  get '/login' do
    redirect to('/') if has_auth?
    slim :login
  end


  post '/login' do
    params[:email] << '@berlinracingteam.de' unless params[:email]['@']
    @person = Person.authenticate(params[:email], params[:password])

    if @person
      session[:person_id] = @person.id
      redirect to(params[:next])
    else
      flash.now[:error] = 'Unbekannte E-Mail oder falsches Password eingegeben.'
      slim :login
    end
  end

end

