class Inventory < ApplicationRecord
  belongs_to :varient
  belongs_to :seller
  has_many :shippings, through: :seller
  has_many :quick_buy_items, dependent: :destroy
  
  monetize :price_cents

  validates :source_url, presence: true, uniqueness: true
end
