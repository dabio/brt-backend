# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class Email
  include DataMapper::Resource

  property :id,         Serial
  property :name, String, :required => true,
    :messages => {
      :presence => 'Bitte gib Deinen Namen an, damit wir Dich ansprechen können.'
    }
  property :email,      String, :required => true, :format => :email_address,
    :messages => {
      :presence => 'Wir m&ouml;chten Dir gerne antworten und ben&ouml;tigen daher deine E-Mail.',
      :format => 'Deine E-Mail scheint nicht korrekt zu sein.'
    }
  property :message,    Text, :required => true,
    :messages => {
      :presence => 'Du hast Deine Nachricht nicht eingetragen.'
    }
  property :send_at,    DateTime
  timestamps :at
end

