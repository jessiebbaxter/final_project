class Seller < ApplicationRecord
  has_many :inventories
  has_many :shippings, dependent: :destroy
  validates :domain, presence: true, uniqueness: true
end
