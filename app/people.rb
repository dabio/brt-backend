# encoding: utf-8

module Brt
  class People < App

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
      not_found unless has_admin?
      slim :index, locals: { items: Person.all }
    end

    #
    # POST /
    #
    post '/' do
      not_found unless has_admin?
      person = Person.new(params[:person])

      if person.save
        redirect to('/'), success: 'Erfolgreich gespeichert'
      else
        person.errors.clear! unless params[:person]
        slim :view, locals: { item: person }
      end
    end

    #
    # GET /:id
    #
    get '/:id' do |id|
      not_found unless has_admin? || current_person.id == id.to_i
      slim :view, locals: { item: Person.get(id) }
    end


    #
    # PUT /:id
    #
    put '/:id' do |id|
      not_found unless has_admin? || current_person.id == id.to_i
      person = Person.get(id)

      if params[:person][:password].nil? or params[:person][:password].empty?
        params[:person].delete 'password'
        params[:person].delete 'password_confirmation'
      end

      if person.update(params[:person])
        redirect to(person.editlink, true, false), success: 'Erfolgreich gespeichert'
      else
        slim :view, locals: { item: person }
      end
    end


    #
    # DELETE /:id
    #
    delete '/:id' do |id|
      not_found unless has_admin?

      Person.get(id).destroy
      flash[:success] = 'Erfolgreich gelöscht'
      to(Person.link, true, false)
    end

  end
end


__END__


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ index
section#people
  header.row
    h2.threequarter Fahrer
    nav.quarter.second
      form action="#{Person.createlink}" method="post"
        button.btn.btn-square.icon-plus Neuer Fahrer

  table.width-100.striped
    thead
      tr
        th Name
        th colspan="2" E-Mail
    tbody
      - for item in items
          tr
            td = item.name
            td
              a.gray-dark href="mailto:#{item.email}" = item.email
            td
              a.icons href="#{item.editlink}" title="Bearbeiten" &#x21;


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ view
section#sponsor

  == slim :_errors, locals: { item: item }

  form.forms.columnar action="#{item.editlink}" method="post"
    - unless item.new?
      input type="hidden" name="_method" value="put"
    ul
      li
        label.bold for="first_name" Vorname <span class="req">*</span>
        input#first_name(type="text" name="person[first_name]" required="required"
          value="#{item.first_name}")
      li
        label.bold for="last_name" Nachname <span class="req">*</span>
        input#last_name(type="text" name="person[last_name]" required="required"
          value="#{item.last_name}")
      li
        fieldset
          section
            label.bold for="email" E-Mail <span class="req">*</span>
          input#email.width-50(type="email" name="person[email]" size="30"
            value="#{item.email}" required="required")
      - if has_admin?
        li
          fieldset
            label
              input type="hidden" name="person[is_admin]" value="0"
              - if item.is_admin
                input#is_admin(type="checkbox" name="person[is_admin]"
                  checked="checked" value="1")  Administrator
              - else
                input#is_admin type="checkbox" name="person[is_admin]"  Administrator
      li.form-section Kennwort
      li.push
        p.gray-light Kennwort ändern. Nur ausfüllen, wenn Kennwort geändert werden soll.
      li
        label.bold for="password" Kennwort
        input#password type="password" name="person[password]"
      li
        label.bold for="password_confirmation" Wiederholung
        input#password_confirmation type="password" name="person[password_confirmation]"
      li.form-section
      li.push
        - if item.new?
          input.btn.icon-floppy type="submit" value="Anlegen"
        - else
          input.btn.icon-floppy type="submit" value="Speichern"
          a.red.delete(href="#{item.deletelink}" data-method="delete"
            data-confirm="Fahrer entfernen?" rel="nofollow") Fahrer entfernen
