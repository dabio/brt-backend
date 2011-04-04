# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class BerlinRacingTeam

  get '/rennen' do
    @events = Event.all(:date.gte => "#{today.year}-01-01",
                        :date.lte => "#{today.year}-12-31",
                        order: [:date, :updated_at.desc])
    slim :events
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
      flash.now[:notice] = 'Rennen erstellt'
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


  get '/rennen/:y/:m/:d/:slug/edit' do
    not_found unless @event = Event.first(
      date: Date.new(params[:y].to_i, params[:m].to_i, params[:d].to_i),
      slug: params[:slug]) and has_admin?

    slim :event_form
  end


  put '/rennen/:y/:m/:d/:slug/edit' do
    not_found unless @event = Event.first(
      date: Date.new(params[:y].to_i, params[:m].to_i, params[:d].to_i),
      slug: params[:slug]) and has_admin?

    if @event.update(params[:event])
      flash.now[:notice] = 'Deine Änderungen wurden gesichert'
      redirect to(@event.editlink)
    end

    slim :event_form
  end

end

