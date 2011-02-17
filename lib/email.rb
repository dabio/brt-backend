#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class Email
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String, :required => true
  property :email,      String, :required => true, :format => :email_address
  property :message,    Text, :required => true
  property :send_at,    DateTime
  timestamps :at
end

