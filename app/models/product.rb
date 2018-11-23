class Product < ApplicationRecord
	has_many :order_items, dependent: :destroy
	has_many :quick_buy_items
  has_many :varients
  has_many :inventories, through: :varients

	validates :name, presence: true
	validates :brand, presence: true

end
