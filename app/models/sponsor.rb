class Sponsor < ActiveRecord::Base
  attr_accessible :image_url, :text, :title, :url

  validates :title, presence: true, length: { maximum: 2000 }
  validates :image_url, presence: true, length: { maximum: 2000 }
  validates :url, length: { maximum: 2000 }
end
