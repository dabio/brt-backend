# encoding: utf-8

module Brt
  class App

    configure do
      enable :inline_templates
    end

    get '/' do
      slim :index
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
    section.container.row
      nav.primary.threequarter
        a href="/" title="Dashboard" Dashboard
        a href="#{News.link}" News & Rennberichte
        a href="#{Event.link}" Rennen
        a href="#{Sponsor.link}" Sponsoren
        a href="#{Person.link}" Fahrer

    == slim :_flash
    section.container == yield

    script src="//cdnjs.cloudflare.com/ajax/libs/zepto/1.0rc1/zepto.min.js"
    script src="/js/admin.js"

/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ _flash
- if flash
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
@@ index
h2 Dashboard
