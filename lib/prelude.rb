# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

module Cuba::Prelude
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

