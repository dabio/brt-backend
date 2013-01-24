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
      slim :index, locals: { items: News.all }
    end


    #
    # POST /
    #
    post '/' do
      item = News.new(params[:news])

      if params[:news]
        params[:news][:event_id] = nil unless params[:news][:event_id].length > 0
        params[:news][:person] = current_person
        item = News.create(params[:news])

        if item.saved?
          if params[:news][:event_id]
            flash[:success] = 'Rennbericht erfolgreich angelegt'
          else
            flash[:success] = 'News erfolgreich angelegt'
          end

          redirect(to('/'))
        end
      end

      slim :view, locals: { item: item }
    end


    #
    # GET /:id
    #
    get '/:id' do |id|
      slim :view, locals: { item: News.get(id), events: Event.all_without_news }
    end


    #
    # PUT /:id
    #
    put '/:id' do |id|
      item = News.get(id)
      params[:news][:event_id] = nil unless params[:news][:event_id].length > 0

      if item.update(params[:news])
        if params[:news][:event_id]
          flash[:success] = 'Rennbericht erfolgreich gespeichert'
        else
          flash[:success] = 'News erfolgreich gespeichert'
        end

        redirect to(item.editlink, true, false)
      end

      slim :view, locals:  { item: item, events: Event.all_without_news }
    end


    #
    # DELETE /:id
    #
    delete '/:id' do |id|
      not_found unless item = News.get(id)
      if item.destroy
        flash[:success] = 'Erfolgreich gelöscht'
        to('/')
      else
        to(item.editlink)
      end
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
  form.forms.columnar action="#{item.editlink}" method="post"
    - unless item.new?
      input type="hidden" name="_method" value="put"
    ul
      li
        label.bold for="date" Datum <span class="req">*</span>
        input#date(type="date" name="news[date]" value="#{item.date}"
          placeholder="#{today}" required="required")
      li
        fieldset
          section
            label.bold for="title" Titel <span class="req">*</span>
          input#title.width-100(type="text" name="news[title]" size="60"
            value="#{item.title}" required="required")
      li
        fieldset
          section
            label.bold for="teaser" Teaser <span class="req">*</span>
          textarea#teaser.width-100 name="news[teaser]" style="height: 54px" = \
            item.teaser
      li
        fieldset
          section
            label.bold for="message" Text
          textarea#message.width-100 name="news[message]" style="height: 387px" = \
            item.message
          span.descr Text wird mit <a class="gray" href="http://daringfireball.net/projects/markdown/dingus" title="Markdown Web Dingus">Markdown</a> formatiert.
      li
        select#event_id name="news[event_id]" site="1" style="width:570px"
          option value="" (leer)
          - for event in events
            option value="#{event.id}" #{event.date_formatted} - #{event.title}, #{event.distance} km
        label.bold for="event_id" Rennen
        span.descr Nur Für Rennberichte.
      li.form-section
      li.push
        - if item.new?
          input.btn type="submit" value="Anlegen"
        - else
          input.btn type="submit" value="Speichern"
          a.red.delete href="#{item.deletelink}" title="Nachricht oder Rennbericht löschen?" Eintrag löschen
