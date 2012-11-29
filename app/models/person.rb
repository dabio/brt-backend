# encoding: utf-8

class Person
  include DataMapper::Resource

  attr_accessor :index

  property :id,         Serial
  property :first_name, String, required: true
  property :last_name,  String, required: true
  property :email,      String, required: true, format: :email_address, unique: true
  property :password,   SCryptHash, required: true
  property :info,       Text, lazy: false
  timestamps :at
  property :slug,       String, length: 2000, default: lambda { |r, p|
    r.name.to_url
  }

  has 1, :visit
  has n, :news
  has n, :reports
  has n, :comments
  has n, :participations
  has n, :events, through: :participations

  attr_accessor :password_confirmation

  validates_confirmation_of :password, if: :password_required?

  default_scope(:default).update(order: [:last_name, :first_name])

  before :destroy do |person|
    # participations
    person.participations.each do |p|
      p.destroy
    end if person.participations
  end

  def name
    "#{first_name} #{last_name}"
  end

  def editlink
    "/admin/people/#{id}"
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



