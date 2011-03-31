# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class BerlinRacingTeam

  get '/css/:stylesheet.css' do
    content_type 'text/css', charset: 'UTF-8'
    cache_control :public, max_age: 29030400
    scss :"css/#{params[:stylesheet]}"
  end

end
