# coding:utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db/local.db?encoding=utf8')

module DataMapper
  class Property

    class BCryptHash < String

      length 60

      def primitive?(value)
        value.kind_of?(BCrypt::Password)
      end

      def load(value)
        unless value.nil?
          begin
            primitive?(value) ? value : BCrypt::Password.new(value)
          rescue BCrypt::Errors::InvalidHash
            BCrypt::Password.create(value, :cost => BCrypt::Engine::DEFAULT_COST)
          end
        end
      end

      def dump(value)
        load(value)
      end

      def typecast_to_primitive(value)
        load(value)
      end
    end


    class URI < String
      # Maximum length chosen based on recommendation:
      # http://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-an-url
      length 2000

      def custom?
        true
      end

      def primitive?(value)
        value.kind_of?(Addressable::URI)
      end

      def valid?(value, negated = false)
        super || primitive?(value) || value.kind_of?(::String)
      end

      def load(value)
        Addressable::URI.parse(value)
      end

      def dump(value)
        value.to_s unless value.nil?
      end

      def typecast_to_primitive(value)
        load(value)
      end
    end # class URI

  end
end


class Comment
  include DataMapper::Resource

  property :id,     Serial
  property :text,   Text
  timestamps :at

  belongs_to :person
  belongs_to :debate, :required => false
  belongs_to :news,   :required => false
  belongs_to :event,  :required => false
  

  validates_presence_of :text

  def permalink
    "/diskussion/#{debate.id}/##{id}"
  end
end


class Debate
  include DataMapper::Resource

  property :id,     Serial
  property :title,  String
  timestamps :at

  belongs_to :person
  has n, :comments

  validates_presence_of :title

  def editlink
    "#{permalink}/edit"
  end

  def permalink
    "/diskussionen/#{id}"
  end
end


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


class Event
  include DataMapper::Resource

  property :id,         Serial
  property :date,       Date
  property :title,      String, :length => 250
  property :url,        URI
  property :distance,   Integer
  #property :type,       Enum[:race, :training], :default => :race
  timestamps :at
  property :slug,       String, :length => 2000, :default => lambda { |r, p|
    slugify(r.title)
  }
 
  belongs_to :person
  has n, :reports
  has n, :comments
  has n, :participations
  has n, :people, :through => :participations

  validates_presence_of :date, :title, :distance#, :type

#  after :save do |event|
#    # save link in mixing table
#    Mixing.first_or_create(:event => event).update(:date => event.date)
#  end

  def permalink
    "/rennen/#{date.strftime("%Y/%m/%d")}/#{slug}"
  end

  def editlink
    "#{permalink}/edit"
  end
end


class News
  include DataMapper::Resource

  property :id,         Serial
  property :date,       Date
  property :title,      String, :length => 250
  property :message,    Text, :lazy => false
  timestamps :at
  property :slug,       String, :length => 2000, :default => lambda { |r, p|
    slugify(r.title)
  }
  #is :slug, :source => :title

  belongs_to :person

  has n, :comments

  validates_presence_of :title, :date, :message

  #after :save do |news|
  #  # save link in mixing table
  #  Mixing.first_or_create(:news => news).update(:date => news.date)
  #end

  def permalink
    "/news/#{date.strftime("%Y/%m/%d")}/#{slug}"
  end

  def editlink
    "#{permalink}/edit"
  end
end


class Participation
  include DataMapper::Resource

  property :person_id,  Integer, :key => true
  property :event_id,   Integer, :key => true
  property :position_overall,   Integer
  property :position_age_class, Integer
  timestamps :at

  belongs_to :person,   :key => true
  belongs_to :event,    :key => true
end


class Person
  include DataMapper::Resource

  property :id,         Serial
  property :first_name, String, :required => true
  property :last_name,  String, :required => true
  property :email,      String, :required => true, :format => :email_address,
    :unique => true
  #property :password,   BCryptHash, :required => true
  property :info,       Text
  timestamps :at
  property :slug,       String, :length => 50, :default => lambda { |r, p|
    slugify(r.name)
  }

  #has 1, :visit
  has n, :news
  has n, :reports
  has n, :comments
  has n, :comments
  has n, :participations
  has n, :events, :through => :participations

  attr_accessor :password_confirmation

  validates_confirmation_of :password, :if => :password_required?

  def image_url
    "/people/#{slug}.jpg"
  end

  def avatar_url
    "/people/#{slug}_avatar.jpg"
  end

  def medium_url
    "/people/#{slug}_medium.jpg"
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


class Report
  include DataMapper::Resource

  property :id,     Serial
  property :date,   Date
  property :text,   Text
  timestamps :at

  belongs_to :person
  belongs_to :event

  validates_presence_of :date, :text
end


