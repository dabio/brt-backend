# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class Person
  include DataMapper::Resource

  attr_accessor :index

  property :id,         Serial
  property :first_name, String, required: true
  property :last_name,  String, required: true
  property :email,      String, required: true, format: :email_address, unique: true
  property :password,   BCryptHash, required: true
  property :info,       Text, lazy: false
  timestamps :at
  property :slug,       String, length: 2000, default: lambda { |r, p|
    r.name.to_url
  }

  has 1, :visit
  has n, :news
  has n, :reports
  has n, :comments
  has n, :comments
  has n, :participations
  has n, :events, through: :participations

  attr_accessor :password_confirmation

  validates_confirmation_of :password, if: :password_required?

  default_scope(:default).update(order: [:last_name, :first_name])

  def people_list_class_name
    result = 'hentry'
    result << ' last' if index % 4 == 3
    result
  end

  def image_url
    "/people/big/#{slug}_big.jpg"
  end

  def avatar_url
    "/people/avatar/#{slug}_avatar.jpg"
  end

  def medium_url
    "/people/medium/#{slug}_medium.jpg"
  end

  def name
    "#{first_name} #{last_name}"
  end
  
  def permalink
    "/team/#{slug}"
  end

  def editlink
    "/admin#{permalink}"
  end

  def deletelink
    editlink
  end

  def createlink
    '/admin/team/new'
  end

  def events_distance(year=nil)
    if year
      participations.inject(0) do |s,v|
        v.date.year == year ? s+=v.event.distance : s+=0
      end
    else
      events.inject(0) { |s,v| s+=v.distance }
    end
  end

  def participations_count(year=nil)
    if year
      participations.inject(0) { |s,v| (v.date.year == year and v.date <= Date.today) ? s+=1 : s+=0 }
    else
      participations.length
    end
  end

  def participations_top10_count(year=nil)
    if year
      participations.inject(0) do |s,v|
        (v.date.year == year and v.position_overall.to_i < 11 and !v.position_overall.nil?) ? s+=1 : s+=0
      end
    else
      participations.inject(0) { |s,v| v.position_overall.to_i < 11 ? s+=1 : s+=0 }
    end
  end

  def self.authenticate(email, password)
    return nil unless person = Person.first(email: email)
    person.password == password ? person : nil
  end

private
  def password_required?
    !password.empty?
  end
end



