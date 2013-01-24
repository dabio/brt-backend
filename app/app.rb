# encoding: utf-8

module Brt
  class App < Boot

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
      nav.threequarter
        a href="/" title="Dashboard" Dashboard
        a href="#{News.link}" title="News & Rennberichte" News & Rennberichte
        a href="#{Sponsor.link}" title="Sponsoren" Sponsoren
        a href="#{Person.link}" title="Fahrer" Fahrer

    == slim :_flash

    section.container == yield

/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ _flash
- if flash
  section.container.flash
    - flash.each do |type, message|
      section class="#{type}" = message

/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ index
h2 Dashboard
