# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class BerlinRacingTeam

  post '/comments/new' do
    not_found unless has_auth?

    @foreign_model = Kernel.const_get(params[:type]).first(id: params[:type_id])
    @comment = Comment.new(text: params[:text],
                           params[:type].downcase => @foreign_model,
                           person: current_person)
    if @comment.save
      @foreign_model.update updated_at: Time.now
      redirect to("#{@foreign_model.permalink}#comment_#{@comment.id}")
    else
      redirect to(@foreign_model.permalink)
    end
  end

end

