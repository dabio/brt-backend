# encoding: utf-8

module Brt
  class AdminPeople < Admin

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
    # GET /admin/people
    #
    get '/' do
      slim :index, locals: { items: Person.all }
    end


    #
    # POST /admin/people
    #
    post '/' do
      item = Person.new(params[:person])

      if params[:person]
        item = Person.create(params[:person])
        if item.saved?
          flash[:success] = 'Neuen Fahrer erfolgreich angelegt'
          redirect(to('/'))
        end
      end

      slim :view, locals: { item: item }
    end


    #
    # GET /admin/people/:id
    #
    get '/:id' do |id|
      slim :view, locals: { item: Person.get(id) }
    end


    #
    # PUT /admin/people/:id
    #
    put '/:id' do |id|
      item = Person.get(id)

      if params[:person][:password].nil? or params[:person][:password].empty?
        params[:person].delete 'password'
        params[:person].delete 'password_confirmation'
      end

      params[:person][:is_admin] = !params[:person][:is_admin].nil?

      flash[:success] = 'Einstellungen gespeichert'
      item.update(params[:person])

      redirect to(item.editlink, true, false)
    end


    #
    # DELETE /admin/people/:id
    #
    delete '/:id' do |id|
      not_found unless item = Person.get(id)
      if item.destroy
        flash[:success] = 'Person erfolgreich gelöscht'
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
section#people
  header.row
    h2.threequarter Fahrer
    nav.quarter.second
      form action="/admin/people" method="post"
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
  form.forms.columnar action="#{item.editlink}" method="post"
    fieldset
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
              section
                label
                  - if item.is_admin
                    input#is_admin(type="checkbox" name="person[is_admin]"
                      checked="checked") Administrator
                  - else 
                    input#is_admin type="checkbox" name="person[is_admin]" Administrator
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
            input.btn type="submit" value="Anlegen"
          - else
            input.btn type="submit" value="Speichern"
            - if has_admin?
              a.red.delete href="#{item.deletelink}" title="Fahrer entfernen?" Fahrer entfernen
