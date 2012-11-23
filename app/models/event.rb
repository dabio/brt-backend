# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class Event
  include DataMapper::Resource
  include DataMapper::Paginator

  attr_accessor :selected

  property :id,         Serial
  property :date,       Date,   required: true
  property :title,      String, required: true, length: 250
  property :url,        URI
  property :distance,   Integer,required: true
  property :type,       Integer, default: 1 #Enum[:race, :training], default: :race
  timestamps :at
  property :slug,       String, length: 2000, default: lambda { |r, p|
    r.title.to_url
  }
  belongs_to :person
  has 1, :news
  has n, :reports
  has n, :comments
  has n, :participations
  has n, :people, :through => :participations

  #validates_presence_of :date, :title, :distance#, :type

  default_scope(:default).update(order: [:date, :updated_at.desc])

#  after :save do |event|
#    # save link in mixing table
#    Mixing.first_or_create(:event => event).update(:date => event.date)
#  end

  # Remove all associations of the current event.
  before :destroy do |event|
    # comments
    event.comments.each do |c|
      c.destroy
    end
    # participations
    event.participations.each do |p|
      p.destroy
    end
    # news
    event.news.each do |n|
      n.update(event=nil)
    end
  end

  def date_formatted
    date.strftime '%-d. %b. %y'
    #R18n::l(date)
  end

  def deletelink
    editlink
  end

  def editlink
    "/admin/events/#{id}"
  end

  def self.all_without_news
    all(:date.lte => Date.today,
      :news.not => News.all(:event.not => nil),
      order: [:date.desc, :updated_at.desc],
      limit: 10
     )
  end

end
