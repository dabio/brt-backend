# encoding: utf-8

module Brt
  class Events < App

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
      slim :index, locals: { items: Event.all }
    end

    #
    # POST /
    #
    post '/' do
      event = Event.new(params[:event])
      event.person = current_person

      if event.save
        redirect to('/'), success: 'Erfolgreich gespeichert'
      else
        slim :view, locals: { item: event }
      end
    end

    #
    # GET /:id
    #
    get '/:id' do |id|
      slim :view, locals: { item: Event.get(id) }
    end


    #
    # PUT /:id
    #
    put '/:id' do |id|
      event = Event.get(id)

      if event.update(params[:event])
        # Destroy all previous participations.
        Participation.all(event: event).destroy
        params[:p].each_value do |p|
          next unless p.include?('person_id')
          p = p.reject { |key, value| value.empty? }.merge({ event_id: id })
          Participation.create(p)
        end

        redirect to(event.editlink, true, false), success: 'Erfolgreich gespeichert'
      else
        slim :view, locals: { item: event }
      end
    end


    #
    # DELETE /:id
    #
    delete '/:id' do |id|
      Event.get(id).destroy
      flash[:success] = 'Erfolgreich gelöscht'
      to(Event.link, true, false)
    end

  end
end


__END__


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ index
section#event
  header.row
    h2.threequarter Rennen
    nav.quarter.second
      form action="#{Event.createlink}" method="post"
        button.btn.btn-square.icon-plus Neues Rennen

  table.width-100.striped
    thead
      tr
        th.date Datum
        th colspan="2" Bezeichnung
    tbody
      - for item in items
          tr
            td.date = item.date_formatted
            td = item.title
            td
              a.icons href="#{item.editlink}" title="Bearbeiten" &#x21;


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ view
section#event
  form.forms.columnar action="#{item.editlink}" method="post"
    - unless item.new?
      input type="hidden" name="_method" value="put"
    ul
      li
        label.bold for="date" Datum <span class="req">*</span>
        input#date(type="date" name="event[date]" value="#{item.date}"
          placeholder="#{today}" required)
      li
        label.bold for="title" Bezeichnung <span class="req">*</span>
        input#title(type="text" name="event[title]" size="60"
          value="#{item.title}" required)
      li
        label.bold for="distance" Distanz <span class="req">*</span>
        input#distance(type="text" name="event[distance]" size="3"
          value="#{item.distance}" placeholder="80" required)
        span.descr  km
      li
        label.bold for="url" URL
        input#url(type="url" name="event[url]" size="60" value="#{item.url}"
          placeholder="http://")

      - unless item.new?
        li.form-section Teilnehmer
        li
          fieldset
            table.width-100.simple.stroked
              thead
                th colspan="2"
                th Gesamt
                th AK
              tbody
                - for p in item.participations
                  tr
                    td
                      input(type="checkbox" name="p[#{p.person.id}][person_id]"
                        value="#{p.person.id}" id="person_#{p.person.id}" checked)
                    td
                      label for="person_#{p.person.id}" = p.person.name
                    td
                      input(type="text" name="p[#{p.person.id}][position_overall]"
                        value="#{p.position_overall}" size="4")
                    td
                      input(type="text" name="p[#{p.person.id}][position_age_class]"
                        value="#{p.position_age_class}" size="4")
                - for p in item.non_participations
                  tr
                    td
                      input(type="checkbox" name="p[#{p.id}][person_id]"
                        id="person_#{p.id}" value="#{p.id}")
                    td
                      label for="person_#{p.id}" = p.name
                    td
                      input type="text" name="p[#{p.id}][position_overall]" size="4"
                    td
                      input type="text" name="p[#{p.id}][position_age_class]" size="4"
      li.form-section
      li.push
        - if item.new?
          input.btn.icon-floppy type="submit" value="Anlegen"
        - else
          input.btn.icon-floppy type="submit" value="Speichern"
          a.red.delete(href="#{item.deletelink}" data-method="delete"
            data-confirm="Rennen entfernen?" rel="nofollow") Rennen entfernen
