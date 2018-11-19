class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  monetize :amount_cents

  validates :user_id, presence: true

end
