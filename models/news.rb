# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class News
  include DataMapper::Resource

  attr_accessor :index

  property :id,         Serial
  property :date,       Date
  property :title,      String, length: 250
  property :teaser,     Text
  property :message,    Text
  timestamps :at
  property :slug,       String, length: 2000, default: lambda { |r, p|
    slugify(r.title)
  }
  #is :slug, :source => :title

  belongs_to :person, required: true
  belongs_to :event

  has n, :comments

  validates_presence_of :title, :date, :teaser

  default_scope(:default).update(order: [:date.desc, :updated_at.desc])

  #after :save do |news|
  #  # save link in mixing table
  #  Mixing.first_or_create(:news => news).update(:date => news.date)
  #end

  def full_date
    R18n::l date, :full
  end

  def index_class_name
    result = 'news-box'
    result << '-last' if index % 3 == 2
    result
  end

  def index_divider
    index == 2
  end

  def permalink
    "/news/#{date.strftime("%Y/%m/%d")}/#{slug}"
  end

  def commentlink
    "#{permalink}#comment"
  end

  def deletelink
    "#{permalink}#delete"
  end

  def editlink
    "#{permalink}#edit"
  end

  def self.paginated(options={})
    page = options.delete(:page) || 1
    per_page = options.delete(:per_page) || 5

    options.reverse_merge!({
      :order => [:id.desc]
    })

    page_count = (count(options.except(:order)).to_f / per_page).ceil

    options.merge!({
      :limit => per_page,
      :offset => (page - 1) * per_page
    })

    [ page_count, all(options) ]
  end
end


