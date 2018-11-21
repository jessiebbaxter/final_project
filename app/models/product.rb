class Product < ApplicationRecord
	has_many :order_items
	has_many :quick_buy_items
  has_many :varients

	monetize :price_cents

	validates :name, presence: true
	validates :brand, presence: true
	validates :description, presence: true

	mount_uploader :photo, PhotoUploader
end
