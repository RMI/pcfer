class Vendor < ApplicationRecord
  has_many :products, dependent: :destroy

  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
end
