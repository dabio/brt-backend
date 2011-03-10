# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#
require './lib/dm'


class Person
  include DataMapper::Resource

  property :id,         Serial
  property :first_name, String, :required => true
  property :last_name,  String, :required => true
  property :email,      String, :required => true, :format => :email_address,
    :unique => true
  property :password,   BCryptHash, :required => true
  property :info,       Text
  timestamps :at
  property :slug,       String, :length => 50, :default => lambda { |r, p|
    slugify(r.name)
  }

  #has 1, :visit
  has n, :news
  has n, :reports
  has n, :threads
  has n, :comments
  has n, :participations
  has n, :events, :through => :participations

  attr_accessor :password_confirmation

  validates_confirmation_of :password, :if => :password_required?

  def image_url
    "#{cdn}/people/#{slug}.jpg"
  end

  def avatar_url
    "#{cdn}/people/#{slug}_avatar.jpg"
  end

  def medium_url
    "#{cdn}/people/#{slug}_medium.jpg"
  end

  def name
    "#{first_name} #{last_name}"
  end
  
  def permalink
    "/team/#{slug}"
  end

  def editlink
    "#{permalink}/edit"
  end

private
  def password_required?
    !password.empty?
  end
end



