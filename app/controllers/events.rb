# encoding: utf-8

module Brt
  class Events < App

    configure do
      enable :inline_templates
    end

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
      count, events = Event.paginated(
        order: [:date.desc, :updated_at.desc], page: current_page, per_page: 20
      )
      erb :events, locals: {
        events: events, page: current_page, page_count: count, title: 'Rennen'
      }
    end

    #
    # POST /
    #
    post '/' do
      event = Event.new(params[:event])
      event.person = current_person

      if event.save
        redirect to('/'), success: 'Erfolgreich gespeichert'
      else
        event.errors.clear! unless params[:event]
        erb :event_form, locals: { event: event, title: 'Neues Rennen' }
      end
    end

    #
    # GET /:id
    #
    get '/:id' do |id|
      event = Event.get(id)
      erb :event_form, locals: { event: event, title: event.title }
    end

    #
    # PUT /:id
    #
    put '/:id' do |id|
      event = Event.get(id)

      if event.update(params[:event])
        # Destroy all previous participations.
        Participation.all(event: event).destroy
        params[:p].each_value do |p|
          next unless p.include?('person_id')
          p = p.reject { |key, value| value.empty? }.merge({ event_id: id })
          Participation.create(p)
        end

        redirect to(event.editlink, true, false), success: 'Erfolgreich gespeichert'
      else
        erb :event_form, locals: { event: event, title: event.title }
      end
    end

    #
    # DELETE /:id
    #
    delete '/:id' do |id|
      Event.get(id).destroy
      flash[:success] = 'Erfolgreich gelöscht'
      to(Event.link, true, false)
    end

    #
    # POST /:id/participation
    #
    post '/:id/participations', :provides => :json do |id|
      Participation.first_or_create({
        event: Event.get(id),
        person: current_person
      }).to_json({
        only: [:id],
        relationships: { person: { methods: [:name], only: [:id] } }
      })
    end

    #
    # DELETE /:id/participation
    #
    delete '/:id/participations' do |id|
      Participation.all(event: Event.get(id), person: current_person).destroy
    end

  end
end
