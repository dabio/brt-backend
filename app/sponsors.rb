# encoding: utf-8

module Brt
  class Sponsors < App

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
      slim :index, locals: { items: Sponsor.all }
    end


    #
    # POST /
    #
    post '/' do
      item = Sponsor.new(params[:sponsor])

      if params[:sponsor]
        item = Sponsor.create(params[:sponsor])
        if item.saved?
          flash[:success] = 'Neuen Sponsor erfolgreich angelegt'
          redirect(to('/'))
        end
      end

      slim :view, locals: { item: item }
    end


    #
    # GET /:id
    #
    get '/:id' do |id|
      slim :view, locals: { item: Sponsor.get(id) }
    end


    #
    # PUT /:id
    #
    put '/:id' do |id|
      item = Sponsor.get(id)

      flash[:success] = 'Sponsor gespeichert'
      item.update(params[:sponsor])

      redirect to(item.editlink, true, false)
    end


    #
    # DELETE /:id
    #
    delete '/:id' do |id|
      not_found unless item = Sponsor.get(id)
      if item.destroy
        flash[:success] = 'Sponsor erfolgreich gelöscht'
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
section#sponsors
  header.row
    h2.threequarter Sponsoren
    nav.quarter.second
      form action="#{Sponsor.createlink}" method="post"
        button.btn.btn-square.icon-plus Neuer Sponsor

  table.width-100.striped
    tbody
      - for item in items
          tr
            td
              img src="#{item.image_url}" alt="#{item.title}"
            td
              a.icons href="#{item.editlink}" title="Bearbeiten" &#x21;


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ view
section#sponsor
  form.forms.columnar action="#{item.editlink}" method="post"
    - unless item.new?
      input type="hidden" name="_method" value="put"
    ul
      li
        fieldset
          section
            label.bold for="title" Titel <span class="req">*</span>
          input#title.width-100 type="text" name="sponsor[title]" size="60" value="#{item.title}" required="required"
      li
        fieldset
          section
            label.bold for="image_url" Bild Url <span class="req">*</span>
          input#image_url.width-100 type="url" name="sponsor[image_url]" size="60" value="#{item.image_url}" placeholder="http://" required="required"
      li
        fieldset
          section
            label.bold for="url" Homepage
          input#url.width-100 type="url" name="sponsor[url]" size="60" value="#{item.url}" placeholder="http://"
      li
        fieldset
          section
            label.bold for="text" Beschreibung
          textarea#text.width-100 name="sponsor[text]" style="height: 387px" = item.text
      li.form-section
      li.push
        - if item.new?
          input.btn type="submit" value="Anlegen"
        - else
          input.btn type="submit" value="Speichern"
          a.red.delete href="#{item.deletelink}" title="Sponsor entfernen?" Sponsor entfernen
