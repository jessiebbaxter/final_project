class Inventory < ApplicationRecord
  belongs_to :varient
  belongs_to :seller

  monetize :price_cents

  validates :source_url, presence: true, uniqueness: true
end
