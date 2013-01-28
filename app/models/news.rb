# encoding: utf-8

class News < Base
  include DataMapper::Resource

  property :id,         Serial
  property :date,       Date, required: true, default: Date.today
  property :title,      String, required: true, length: 250
  property :teaser,     Text, required: true
  property :message,    Text
  timestamps :at
  property :slug,       String, length: 2000, default: lambda { |r, p|
    r.title.to_url unless r.title.nil?
  }

  belongs_to :person
  belongs_to :event, required: false

  has n, :comments

  default_scope(:default).update(order: [:date.desc, :updated_at.desc])

  # Remove all associated data from this news.
  before :destroy do |news|
    news.comments.each do |comment|
      comment.destroy
    end if news.comments
  end

  # remove the event_id when no event is set
  def event_id=(event_id)
    event_id = nil unless event_id.length > 0
    super
  end

  def date_formatted
    R18n::l(date, '%-d. %b %y')
  end

  def self.link
    '/news'
  end

end
