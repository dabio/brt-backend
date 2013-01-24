# encoding: utf-8

class News < Base
  include DataMapper::Resource

  property :id,         Serial
  property :date,       Date
  property :title,      String, length: 250
  property :teaser,     Text
  property :message,    Text
  timestamps :at
  property :slug,       String, length: 2000, default: lambda { |r, p|
    r.title.to_url
  }

  belongs_to :person
  belongs_to :event, required: false

  has n, :comments

  validates_presence_of :title, :date, :teaser

  default_scope(:default).update(order: [:date.desc, :updated_at.desc])

  # Remove all associated data from this news.
  before :destroy do |news|
    news.comments.each do |comment|
      comment.destroy
    end if news.comments
  end

  def date_formatted
    date.strftime '%-d. %b. %y'
    #R18n::l(date)
  end

  def self.link
    '/news'
  end

end
