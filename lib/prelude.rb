# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

module Cuba::Prelude
  def authenticate(email, password)
    return nil unless person = Person.first(:email => email)
    person.password == password ? person : nil
  end

  def current_person
    unless @current_person
      @auth ||= Rack::Auth::Basic::Request.new(env)
      if @auth.provided? and @auth.basic? and @auth.credentials
        @auth.credentials[0] << '@berlinracingteam.de' unless @auth.credentials[0]['@']
        @current_person = authenticate(@auth.credentials[0], @auth.credentials[1])
      end
    end
    @current_person
  end

  # Fixes encoding issue by defaulting to UTF-8
  def force_encoding(data, encoding = 'UTF-8')
    if data.respond_to? :force_encoding
      data.force_encoding encoding
    elsif data.respond_to? :each_value
      data.each_value { |v| v.force_encoding(encoding) }
    elsif data.respond_to? :each
      data.each { |v| v.force_encoding(encoding) }
    end
    data
  end

  # overwrite cuba param method for getting utf-8 compatible paramters
  def param(key, default = nil)
    lambda { captures << (force_encoding(req[key]) || default) }
  end

  def stylesheet(template)
    if req.query_string =~ /^\w{5}$/
      res.headers['Cache-Control'] = 'public, max-age=29030400'
    end
    res.headers['Content-Type'] = 'text/css; charset=utf-8'
    render("views/#{template}")
  end

  def navigation
    {
      '/' => 'Home',
      '/team' => 'Team',
      '/rennen' => 'Rennen',
      '/kontakt' => 'Kontakt'
    }
  end

  def footer
    @events = Event.all(:date.gte => Date.today, :order => [:date, :updated_at.desc],
                        :limit => 3)
    @people ||= Person.all(:order => [:last_name, :first_name])
    partial 'footer'
  end

  def partial(template, locals = {})
    render "views/partials/#{template}.slim", locals
  end

  # Wraps the common case of throwing a 404 page in a nice little helper.
  #
  # @example
  #
  #   on path("user"), segment do |_, id|
  #     break not_found unless user = User[id]
  #
  #     res.write user.username
  #   end
  def not_found
    res.status = 404
    res.write render 'views/404.slim'
  end

  def send_email(to, opts={})
    require 'net/smtp'

    opts[:server]     ||= 'smtp.sendgrid.net'
    opts[:port]       ||= 25
    opts[:user]       ||= ENV["SENDGRID_USERNAME"]
    opts[:password]   ||= ENV["SENDGRID_PASSWORD"]

    msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}

#{opts[:body]}
END_OF_MESSAGE

    Net::SMTP.start(opts[:server], opts[:port], opts[:from], opts[:user], opts[:password], :plain) do |smtp|
      smtp.send_message msg, opts[:from], to
    end
  end
end

