# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class BerlinRacingTeam

  get '/team' do
    @people = Person.all :order => [:last_name, :first_name]
    slim :people
  end


  get '/team/:slug' do
    not_found unless @person = Person.first(:slug => params[:slug])
    @participations = Participation.get_person_results(@person.id) || []
    slim :person
  end


  get '/team/:slug/edit' do
    not_found unless @person = Person.first(slug: params[:slug])

    if @person == current_person or has_admin?
      slim :person_form
    else
      not_found
    end
  end


  put '/team/:slug/edit'do
    not_found unless @person = Person.first(slug: params[:slug])

    if @person == current_person or has_admin?
      @person.attributes = {
        :email  => params[:person]['email'],
        :info   => params[:person]['info']
      }

      unless params[:person]['password'].empty?
        @person.password = params[:person]['password']
        @person.password_confirmation = params[:person]['password_confirmation']
      end

      if @person.save
        flash.now[:notice] = 'Änderung gesichert.'
        redirect to(@person.editlink)
      else
        slim :person_form
      end
    else
      not_found
    end
  end

end
