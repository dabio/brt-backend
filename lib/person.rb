# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class Person
  include DataMapper::Resource

  property :id,         Serial
  property :first_name, String
  property :last_name,  String
  property :email,      String, :length => 255
  #property :password,   BCryptHash
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
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email

  def image_url
    "#{settings.cdn}people/#{slug}.jpg"
  end

  def avatar_url
    "#{settings.cdn}people/#{slug}_avatar.jpg"
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



