# encoding: utf-8

module Brt

  class App

    helpers Sinatra::RedirectWithFlash

    helpers do
      include Rack::Utils
      alias_method :h, :escape_html

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

      def pagination(page, page_count, url)
        Array.new(page_count) do |i|
          if i+1 == page
            { title: i+1 }
          elsif i == 0
            { title: i+1, href: url }
          else
            { title: i+1, href: "#{url}?page=#{i+1}" }
          end
        end
      end

      def today
        Date.today
      end

      # checks for authorized user and redirects to the login page if user
      # is not authorized.
      def authorize!
        redirect to("/login?to=#{request.path}", true, false) unless has_auth?
      end

    end

  end

end
