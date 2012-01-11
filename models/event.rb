# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

require(root_path('models/dm'))

class Event
  include DataMapper::Resource

  attr_accessor :index, :new_month

  property :id,         Serial
  property :date,       Date,   required: true
  property :title,      String, required: true, length: 250
  property :url,        URI
  property :distance,   Integer,required: true
  property :type,       Enum[:race, :training], default: :race
  timestamps :at
  property :slug,       String, length: 2000, default: lambda { |r, p| slugify r.title }
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

  def permalink
    if news
      news.permalink
    else
      "/rennen/#{date.strftime("%Y/%m/%d")}/#{slug}"
    end
  end

  def editlink
    "/admin#{date.strftime("%Y/%m/%d")}/#{slug}"
  end

  def deletelink
    editlink
  end

  def participation_editlink
    "#{permalink}/participation"
  end

  def participations_summary
    return if participations.length < 1
    s = ''
    # participations
    if participations.length == 1
      s+= 'Mit einem Teilnehmer'
    else
      s+= "Mit #{participations.length} Teilnehmern"
    end

    # top10
    top10 = participations.inject(0) do |s,v|
      (!v.position_overall.nil? and v.position_overall.to_i < 11) ? s+=1 : s+=0
    end

    if top10 == 1
      s+= ' und einer Top10 Platzierung'
    elsif top10 > 1
      s+= " und #{top10} Top10 Platzierungen"
    end

    s
  end

  def self.all_for_year(year)
    year ||= Date.today.year
    all(:date.gte => "#{year}-01-01", :date.lte => "#{year}-12-31")
  end

  def self.all_without_news
    all(:date.lte => Date.today,
      :news.not => News.all(:event.not => nil),
      order: [:date.desc, :updated_at.desc], limit: 10
    )
  end

end

