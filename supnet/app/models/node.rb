class Node < ApplicationRecord
  validates_presence_of :owner, :url

  has_many :sources
  has_many :products, through: :sources

end
