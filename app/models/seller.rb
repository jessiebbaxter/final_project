class Seller < ApplicationRecord
  has_many :inventories

  validates :domain, presence: true, uniqueness: true
end
