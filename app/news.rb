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
      #not_found unless has_admin?
    end

    #
    # GET /
    #
    get '/' do
      count, news = News.paginated(page: current_page, per_page: 20)
      slim :index, locals: { items: news, page: current_page, page_count: count }
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
        slim :view, locals:  { item: news, events: Event.all_without_news }
      end
    end

    #
    # GET /:id
    #
    get '/:id' do |id|
      news = News.get(id)
      events = Event.all_without_news
      events.insert(0, news.event) unless news.event.nil?

      slim :view, locals: { item: news, events: events }
    end

    #
    # PUT /:id
    #
    put '/:id' do |id|
      news = News.get(id)

      if news.update(params[:news])
        redirect to(news.editlink, true, false), success: 'Erfolgreich gespeichert'
      else
        slim :view, locals:  { item: news, events: Event.all_without_news }
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


__END__


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ index
section#news
  header.row
    h2.threequarter News & Rennberichte
    nav.quarter.second
      form action="#{News.createlink}" method="post"
        button.btn.btn-square.icon-plus Anlegen

  table.width-100.striped
    thead
      tr
        th.date Datum
        th colspan="2" Titel
    tfoot
      tr
        td colspan="3" == slim :_pagination, locals: { page_count: page_count, url: News.link, page: page }
    tbody
      - for item in items
          tr
            td.date = item.date_formatted
            td = item.title
            td
              a.icons href="#{item.editlink}" title="Bearbeiten" &#x21;


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ view
section#news

  == slim :_errors, locals: { item: item }

  form.forms.columnar action="#{item.editlink}" method="post"
    - unless item.new?
      input type="hidden" name="_method" value="put"
    ul
      li
        label.bold for="date" Datum <span class="req">*</span>
        input#date(type="date" name="news[date]" value="#{item.date}"
          placeholder="#{today}" required)
      li
        fieldset
          section
            label.bold for="title" Titel <span class="req">*</span>
          input#title.width-100(type="text" name="news[title]" size="60"
            value="#{item.title}" required)
      li
        fieldset
          section
            label.bold for="teaser" Teaser <span class="req">*</span>
          textarea#teaser.width-100(name="news[teaser]" style="height: 54px"
            required) = item.teaser
      li
        fieldset
          section
            label.bold for="message" Text
          textarea#message.width-100 name="news[message]" style="height: 387px" = \
            item.message
          span.descr Text wird mit <a class="gray" href="http://daringfireball.net/projects/markdown/dingus" title="Markdown Web Dingus">Markdown</a> formatiert.
      li
        select#event_id name="news[event_id]" size="1" style="width:570px"
          option value="" (leer)
          - for event in events
            - if item.event == event
              option value="#{event.id}" selected="selected" #{event.date_formatted} - #{event.title}, #{event.distance} km
            - else
              option value="#{event.id}" #{event.date_formatted} - #{event.title}, #{event.distance} km
        label.bold for="event_id" Rennen
        span.descr Nur Für Rennberichte.
      li.form-section
      li.push
        - if item.new?
          input.btn.icon-floppy type="submit" value="Anlegen"
        - else
          input.btn.icon-floppy type="submit" value="Speichern"
          a.red.delete(href="#{item.deletelink}" data-method="delete"
            data-confirm="Nachricht oder Rennbericht löschen?" rel="nofollow") Eintrag löschen
