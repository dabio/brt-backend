# encoding: utf-8

module Brt
  class NewsApp < App

    configure do
      enable :inline_templates
    end

    #
    # Disallow the admin area for non authorized users.
    #
    before do
      redirect to('/login', true, false) unless has_auth?
    end

    #
    # GET /
    #
    get '/' do
      count, news = News.paginated(page: current_page, per_page: 20)
      erb :news, locals: { news: news, page: current_page, page_count: count }
    end

    #
    # POST /
    #
    post '/' do
      news = News.new(params[:news])
      news.person = current_person

      if news.save
        redirect to('/'), success: 'Erfolgreich gespeichert'
      else
        news.errors.clear! unless params[:news]
        erb :news_form, locals:  { news: news, events: Event.all_without_news }
      end
    end

    #
    # GET /:id
    #
    get '/:id' do |id|
      news = News.get(id)
      events = Event.all_without_news
      events.insert(0, news.event) unless news.event.nil?

      erb :news_form, locals: { news: news, events: events }
    end

    #
    # PUT /:id
    #
    put '/:id' do |id|
      news = News.get(id)

      if news.update(params[:news])
        redirect to(news.editlink, true, false), success: 'Erfolgreich gespeichert'
      else
        erb :news_form, locals:  { news: news, events: Event.all_without_news }
      end
    end

    #
    # DELETE /:id
    #
    delete '/:id' do |id|
      News.get(id).destroy
      flash[:success] = 'Erfolgreich gelöscht'
      to(News.link, true, false)
    end

  end
end
