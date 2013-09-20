# encoding: utf-8

module Brt
  class Sponsors < App

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
      erb :sponsors, locals: { sponsors: Sponsor.all, title: 'Sponsoren' }
    end

    #
    # POST /
    #
    post '/' do
      sponsor = Sponsor.new(params[:sponsor])

      if sponsor.save
        redirect to ('/'), success: 'Erfolgreich gespeichert'
      else
        sponsor.errors.clear! unless params[:sponsor]
        erb :sponsor_form, locals: { sponsor: sponsor, title: 'Neuer Sponsor' }
      end
    end

    #
    # GET /:id
    #
    get '/:id' do |id|
      sponsor = Sponsor.get(id)
      erb :sponsor_form, locals: { sponsor: sponsor, title: sponsor.title }
    end

    #
    # PUT /:id
    #
    put '/:id' do |id|
      sponsor = Sponsor.get(id)

      if sponsor.update(params[:sponsor])
        redirect to(sponsor.editlink, true, false), success: 'Erfolgreich gespeichert'
      else
        erb :sponsor_form, locals: { sponsor: sponsor, title: sponsor.title }
      end
    end

    #
    # DELETE /:id
    #
    delete '/:id' do |id|
      Sponsor.get(id).destroy
      flash[:success] = 'Erfolgreich gelöscht'
      to(Sponsor.link, true, false)
    end

  end
end
