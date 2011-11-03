# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

#
# RENNEN
#
class BerlinRacingTeam

  get '/rennen' do
    not_found unless @events = Event.all(:date.gte => "#{today.year}-01-01",
                                         :date.lte => "#{today.year}-12-31",
                                          order: [:date, :updated_at.desc])
    slim :events
  end


  get '/rennen.ics' do
    @events = Event.all(order: [:date, :updated_at.desc])

    content_type 'text/calendar'
    erb :'ical/events'
  end


  get '/rennen/:y/:m/:d/:slug' do
    date = Date.new params[:y].to_i, params[:m].to_i, params[:d].to_i
    not_found unless @event = Event.first(date: date, slug: params[:slug])
    @report = Report.new if has_admin?

    slim :event
  end


  get '/rennen/:y/:m/:d/:slug/edit' do
    date = Date.new params[:y].to_i, params[:m].to_i, params[:d].to_i
    not_found unless @event = Event.first(date: date, slug: params[:slug])
    not_found unless has_auth?

    slim :event_form
  end


  put '/rennen/:y/:m/:d/:slug/edit' do
    not_found unless has_auth?
    date = Date.new params[:y].to_i, params[:m].to_i, params[:d].to_i
    not_found unless @event = Event.first(date: date, slug: params[:slug])

    if @event.update(params[:event])
      flash[:notice] = 'Deine Änderungen wurden gesichert'
      redirect to(@event.editlink)
    end

    slim :event_form
  end


  post '/rennen/:y/:m/:d/:slug/participation' do |year, month, day, slug|
    not_found unless has_auth?

    date = Date.new year.to_i, month.to_i, day.to_i
    not_found unless event = Event.first(date: date, slug: slug)

    unless Participation.first(event: event, person: current_person)
      Participation.create(event: event, person: current_person)
    end

    'success'
  end


  delete '/rennen/:y/:m/:d/:slug/participation' do |year, month, day, slug|
    not_found unless has_auth?

    date = Date.new year.to_i, month.to_i, day.to_i
    not_found unless event = Event.first(date: date, slug: slug)

    if participation = Participation.first(event: event, person: current_person)
      participation.destroy
    end

    'success'
  end


  delete '/rennen/:y/:m/:d/:slug' do
    date = Date.new params[:y].to_i, params[:m].to_i, params[:d].to_i
    not_found unless event = Event.first(date: date, slug: params[:slug])
    not_found unless has_auth?

    event.destroy
    'success'
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


  get '/rennen/:year' do |year|
    @events = Event.all(:date.gte => "#{year}-01-01",
                        :date.lte => "#{year}-12-31",
                        order: [:date, :updated_at.desc])

    not_found unless @events.length > 0

    slim :events
  end

end

