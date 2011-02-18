# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class News
  include DataMapper::Resource

  property :id,         Serial
  property :date,       Date
  property :title,      String
  property :message,    Text, :lazy => false
  timestamps :at
  property :slug,       String, :length => 50, :default => lambda { |r, p|
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


