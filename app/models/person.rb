class Person < ActiveRecord::Base
  attr_accessible :email, :first_name, :info, :is_admin, :last_name, :password, :password_confirmation, :slug

  validates :first_name,  presence: true, length: { maximum: 50 }
  validates :last_name,   presence: true, length: { maximum: 50 }
  #validates :email,       presence: true, email: true, uniqueness: true, length: { maximum: 255, minumum: 5 }
  validates :password,    presence: true, confirmation: true,
    unless: Proc.new { |a| a.password.blank? }
end
