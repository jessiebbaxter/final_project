class Inventory < ApplicationRecord
  belongs_to :varient
  belongs_to :seller
  belongs_to :coupon
  has_many :quick_buy_items

  monetize :price_cents

  validates :source_url, presence: true, uniqueness: true
end
