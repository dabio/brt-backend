class Person < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :first_name, :info, :is_admin, :last_name, :password, :password_confirmation, :slug

  validates :first_name,  presence: true, length: { maximum: 50 }
  validates :last_name,   presence: true, length: { maximum: 50 }
  validates :email,       presence: true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }, uniqueness: true, length: { maximum: 255, minumum: 5 }
  validates :password,    presence: true, confirmation: true,
    unless: Proc.new { |a| a.password.blank? }

  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end
end
