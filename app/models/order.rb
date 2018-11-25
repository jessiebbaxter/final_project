class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :inventories, through: :order_items

  monetize :amount_cents

  validates :user_id, presence: true
end
