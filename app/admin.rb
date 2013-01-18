# encoding: utf-8

module Brt
  class Admin < Main

    configure do
      enable :inline_templates
    end

    helpers do

      # Returns text transformed into HTML using simple formatting rules. Two or
      # more consecutive newlines(\n\n) are considered as a paragraph and wrapped
      # in <p> or your own tags. One newline (\n) is considered as a linebreak
      # and <br /> tag is appended.
      # This method does not remove the newlines from the text.
      def simple_format(text, options={})
        t = options.delete(:tag) || :p
        start_tag = "<#{t}>"
        text = text.to_s.dup
        text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
        text.gsub!(/\n\n+/, "</#{t}>\n\n#{start_tag}")  # 2+ newline  -> paragraph
        text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
        text.insert 0, start_tag
        text << "</#{t}>"
      end

      # Returns the current page given by the url request parameter. Defaults to
      # 1.
      def current_page
        params[:page] && params[:page].match(/\d+/) ? params[:page].to_i : 1
      end

      # This gives us the currently logged in user. We keep track of that by just
      # setting a session variable with their is. If it doesn't exist, we want to
      # return nil.
      def current_person
        unless @cp and @request.session[:person_id]
          @cp = Person.get(@request.session[:person_id])
        end
        @cp
      end

      # Checks if this is a logged in person
      def has_auth?
        !current_person.nil?
      end

      # Check if current person is logged in and is admin
      def has_admin?
        has_auth? && current_person.is_admin
      end

      def today
        Date.today
      end

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

    == slim :_flash

    section.container == yield

/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ _flash
- if flash
  section.container.flash
    - flash.each do |type, message|
      section class="#{type}" = message



