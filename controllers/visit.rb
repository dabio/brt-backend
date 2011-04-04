# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class BerlinRacingTeam

  put '/visit' do
    not_found unless has_auth?
    Visit.first_or_create(person: current_person).update(created_at: Time.now)
  end

end

