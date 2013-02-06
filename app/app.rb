# encoding: utf-8

module Brt
  class App

    configure do
      enable :inline_templates
    end

    get '/' do
      redirect to('/login') unless has_auth?

      slim :index
    end

    before '/login' do
      redirect to('/') if has_auth?
    end

    get '/login' do
      slim :login, locals: { email: '' }
    end

    post '/login' do
      halt redirect to('/') unless params[:email] and params[:password]

      email = params[:email].clone
      email << '@berlinracingteam.de' unless email['@']
      person = Person.authenticate(email, params[:password])

      if person
        session[:person_id] = person.id
        redirect to('/')
      else
        flash[:error] = 'Unbekannte E-Mail oder falsches Password eingegeben.'
        slim :login, locals: { email: params[:email], flash: flash }
      end
    end

    get '/logout' do
      redirect to('/login') unless has_auth?

      session[:person_id] = nil
      redirect to('/login')
    end

    error do
      'Error'
    end

  end
end


__END__

/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ layout
doctype html
html
  head
    meta charset="utf8"
    title Blah
    link rel="stylesheet" href="/css/kube.min.css"
    link rel="stylesheet" href="/css/master.css"
  body
    header
    - if has_auth?
      section.container.row
        nav.primary.threequarter
          a href="/" title="Dashboard" Dashboard
          a href="#{News.link}" News & Rennberichte
          a href="#{Event.link}" Rennen
          - if has_admin?
            a href="#{Sponsor.link}" Sponsoren
            a href="#{Person.link}" Fahrer
            a href="#{Email.link}" E-Mails
        nav.primary.quarter style="text-align: right"
          a href="#{current_person.editlink}" Einstellungen
          a href="/logout" Abmelden

    == slim :_flash
    section.container == yield

    script src="//cdnjs.cloudflare.com/ajax/libs/zepto/1.0rc1/zepto.min.js"
    script src="/js/admin.js"


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ _flash
- if !flash.empty?
  section.container.flash
    - flash.each do |type, message|
      section class="#{type}" = message


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ _errors
- if item.errors.count > 0
  ul.errors
    - item.errors.full_messages.each do |e|
      li = e


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ _pagination
span.pages Seite #{page} von #{page_count}
span.page-items
  - for p in pagination(page, page_count, url)
    - if p[:href]
      a href="#{p[:href]}" = p[:title]
    - else
      span = p[:title]


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ index
h2 Dashboard


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ login
section#login.row
  h2.third.centered Anmelden
  form.forms.columnar.third.centered action="/login" method="post"
    ul
      -if !email.empty?
        li
          input(type="text" name="email" value="#{email}" required
            placeholder="Benutzername/E-Mail")
        li
          input(type="password" name="password" placeholder="Passwort"
            autofocus="autofocus" required)
      - else
        li
          input(type="text" name="email" autofocus="autofocus" required
            placeholder="Benutzername/E-Mail")
        li
          input(type="password" name="password" placeholder="Passwort" required)
      li
        input.btn type="submit" value="Anmelden"
