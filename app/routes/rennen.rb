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


  get '/rennen/:year' do
    @events = Event.all(:date.gte => "#{params[:year]}-01-01",
                        :date.lte => "#{params[:year]}-12-31",
                        order: [:date, :updated_at.desc])
    slim :events
  end

end

