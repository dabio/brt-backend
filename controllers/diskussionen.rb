# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class BerlinRacingTeam

  get '/diskussionen' do
    not_found unless @debates = Debate.all(order: [:updated_at.desc]) and has_auth?

    slim :debates
  end


  get '/diskussionen/new' do
    not_found unless has_auth?

    @debate = Debate.new
    @comment = Comment.new

    slim :debate_form
  end


  post '/diskussionen/new' do
    not_found unless has_auth?

    @debate = Debate.new params[:debate]
    @debate.person = current_person

    @comment = Comment.new params[:comment]
    @comment.person = current_person
    @comment.debate = @debate

    if @debate.valid? and @comment.valid?
      @debate.save
      @comment.save

      flash[:notice] = 'Thema erfolgreich erstellt.'
      redirect to(@debate.permalink)
    end

    slim :debate_form
  end


  get '/diskussionen/:id' do
    not_found unless @debate = Debate.first(id: params[:id]) and has_auth?

    slim :debate
  end

end

