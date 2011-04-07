# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class BerlinRacingTeam

  put '/team/:slug/edit'do
    not_found unless @person = Person.first(slug: params[:slug])
    not_found unless @person == current_person or has_admin?

    @person.attributes = {
      :email  => params[:person]['email'],
      :info   => params[:person]['info']
    }

    unless params[:person]['password'].empty?
      @person.password = params[:person]['password']
      @person.password_confirmation = params[:person]['password_confirmation']
    end

    if @person.save
      flash[:notice] = 'Änderung gespeichert.'
      redirect to(@person.editlink)
    end

    slim :person_form
  end

end
