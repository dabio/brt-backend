# encoding: utf-8

module Brt

  class Email
    include DataMapper::Resource
    #include Brt::Helpers

    property :id,         Serial
    property :name,       String, required: true,
      messages: {
        presence: 'Bitte gib Deinen Namen an, damit wir Dich ansprechen können.'
      }
    property :email,      String, required: true, :format => :email_address,
      :messages => {
        :presence => 'Wir möchten Dir gerne antworten und benötigen daher deine E-Mail.',
        :format => 'Deine E-Mail scheint nicht korrekt zu sein.'
      }
    property :message,    Text, :required => true,
      :messages => {
        :presence => 'Du hast Deine Nachricht nicht eingetragen.'
      }
    property :send_at,    DateTime
    timestamps :at


    before :save do |e|
      e.send_at = Time.now
      e.send_email
    end


    def date_formatted
      send_at.strftime '%-d. %b. %y'
    end


    def message_formatted
      simple_format(message)
    end


    def editlink
      "/admin/emails/#{id}"
    end


    def send_email(opts={})
      require 'net/smtp'

      opts[:to]         ||= ENV['CONTACT_EMAIL']
      opts[:server]     ||= 'smtp.sendgrid.net'
      opts[:port]       ||= 25
      opts[:user]       ||= ENV['SENDGRID_USERNAME']
      opts[:password]   ||= ENV['SENDGRID_PASSWORD']

      msg = <<END_OF_MESSAGE
From: #{name} <#{email}>
To: <#{opts[:to]}>
Subject: Nachricht von berlinracingteam.de

#{message}
END_OF_MESSAGE

      Net::SMTP.start(opts[:server], opts[:port], opts[:from], opts[:user], opts[:password], :plain) do |smtp|
        smtp.send_message msg, opts[:from], opts[:to]
      end
    end

  end

end
