# encoding: utf-8

module Brt
  module Helpers

    # This gives us the currently logged in user. We keep track of that by just
    # setting a session variable with their is. If it doesn't exist, we want to
    # return nil.
    def current_person
      unless @cu
        @cu = Person.get(@request.session[:person_id]) if @request.session[:person_id]
      end
      @cu
    end

    # Checks if this is a logged in person
    def has_auth?
      true
      #!current_person.nil?
    end

    # Check if current person is logged in and is admin
    def has_admin?
      has_auth? && current_person.id == 1
    end

    # Encrypts given email-strings to format address [at] domain . tld.
    def encrypt_email(email)
      email = '' if email.nil?
      email.gsub! /@/, ' [at] '
      email.gsub! /\./, ' . '
    end

    def l(string, options)
      R18n::l(string, options)
    end

    def markdown(text)
      @markdown = Redcarpet::Markdown.new(
        Redcarpet::Render::HTML, autolink: true, safe_links_only: true
      ) unless @markdown
      @markdown.render(text)
    end

    def month_short(date)
      if [3, 5, 6, 7].include?(date.month)
        l(date, :month)
      else
        "#{l(date, :month)[0..2]}."
      end
    end

    def truncate_words(text, length = 30, end_string = ' …')
      return if text == nil
      words = text.split()
      words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
    end

    # Taken from rails
    AUTO_LINK_RE = %r{(?:([\w+.:-]+:)//|www\.)[^\s<]+}x
    BRACKETS = {']' => '[', ')' => '(', '}' => '{'}
    def auto_link(text, limit=nil)
      trim = lambda {|s, l| l != nil and (s.length > limit and "#{s[0,l-1]}…") or s}
      text.gsub(AUTO_LINK_RE) do
        scheme, href = $1, $&
        punctuation = []
        # don't include trailing punctiation character as part of the URL
        while href.sub!(/[^\w\/-]$/, '')
          punctuation.push $&
          if opening = BRACKETS[punctuation.last] and href.scan(opening).size > href.scan(punctuation.last).size
            href << punctuation.pop
            break
          end
        end

        link_text = block_given? ? yield(href) : href
        href = 'http://' + href unless scheme

        "<a href=\"#{href}\">#{trim[link_text, limit]}</a>" + punctuation.reverse.join('')
      end
    end

    def comment_count(count, comment='Kommentar', comments='Kommentare')
      str = "#{count} #{comments}"
      if count == 0
        str = "ohne #{comment}"
      elsif count == 1
        str = "ein #{comment}"
      end
      str
    end

    # Returns the current page given by the url request parameter. Defaults to 1.
    def current_page
      @page = params[:page] && params[:page].match(/\d+/) ? params[:page].to_i : 1
    end

    def today
      @today = Date.today unless @today
      @today
    end

    def params_date
      Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    end

    def event
      @event ||= Event.first(date: params_date, slug: params[:slug]) || not_found
    end

    def news
      @news ||= News.first(date: params_date, slug: params[:slug]) || not_found
    end

    def person
      @person ||= Person.first(slug: params[:slug]) || not_found
    end

  end
end
