# encoding: utf-8

module Brt
  class People < App

    #
    # Disallow the admin area for non authorized users.
    #
    before do
      authorize!
    end

    #
    # GET /
    #
    get '/' do
      not_found unless has_admin?
      erb :people, locals: { people: Person.all }
    end

    #
    # POST /
    #
    post '/' do
      not_found unless has_admin?
      person = Person.new(params[:person])

      if person.save
        redirect to('/'), success: 'Erfolgreich gespeichert'
      else
        person.errors.clear! unless params[:person]
        erb :person_form, locals: { person: person }
      end
    end

    #
    # GET /:id
    #
    get '/:id' do |id|
      not_found unless has_admin? || current_person.id == id.to_i
      erb :person_form, locals: { person: Person.get(id) }
    end


    #
    # PUT /:id
    #
    put '/:id' do |id|
      not_found unless has_admin? || current_person.id == id.to_i
      person = Person.get(id)

      if params[:person][:password].nil? or params[:person][:password].empty?
        params[:person].delete 'password'
        params[:person].delete 'password_confirmation'
      end

      if person.update(params[:person])
        redirect to(person.editlink, true, false), success: 'Erfolgreich gespeichert'
      else
        erb :person_form, locals: { person: person }
      end
    end


    #
    # DELETE /:id
    #
    delete '/:id' do |id|
      not_found unless has_admin?

      Person.get(id).destroy
      flash[:success] = 'Erfolgreich gelöscht'
      to(Person.link, true, false)
    end

  end
end
