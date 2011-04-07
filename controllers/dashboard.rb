# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class BerlinRacingTeam

  get '/dashboard' do
    not_found unless has_auth?

    @visits = Visit.all(order: [:updated_at.desc])
    slim :dashboard
  end

end


