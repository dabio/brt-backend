# encoding: utf-8

class Event < Base
  include DataMapper::Resource

  property :id,         Serial
  property :date,       Date,   required: true
  property :title,      String, required: true, length: 250
  property :url,        URI
  property :distance,   Integer,required: true
  property :type,       Integer, default: 1 #Enum[:race, :training], default: :race
  timestamps :at
  property :slug,       String, length: 2000, default: lambda { |r, p|
    r.title.to_url unless r.title.nil?
  }
  belongs_to :person
  has 1, :news
  has n, :reports
  has n, :comments
  has n, :participations
  has n, :people, :through => :participations

  default_scope(:default).update(order: [:date.desc, :updated_at.desc])

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
    event.news.update(event=nil) if event.news
  end

  def date_formatted(format='%-d. %b %y')
    R18n::l(date, format)
  end

  def non_participations
    Person.all(is_active: true) - participations.person
  end

  def participationlink
    "#{self.class.link}/#{id}/participations"
  end

  class << self

    def all_without_news
      all(:date.lte => Date.today,
        :news.not => News.all(:event.not => nil),
        order: [:date.desc, :updated_at.desc],
        limit: 10
       )
    end

    def link
      '/events'
    end

  end

end
