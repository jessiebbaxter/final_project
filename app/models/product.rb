class Product < ApplicationRecord
	has_many :order_items
	has_many :quick_buy_items
  has_many :varients

	validates :name, presence: true
	validates :brand, presence: true
end
