class Vendor < ApplicationRecord
  has_many :products, dependent: :destroy
end
