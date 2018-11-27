class Product < ApplicationRecord
	has_many :quick_buy_items
  has_many :varients, dependent: :destroy
  has_many :inventories, through: :varients
  has_many :sellers, through: :inventories

	validates :name, presence: true
	validates :brand, presence: true

  include PgSearch
  pg_search_scope :global_search,
    against: [:name, :brand, :category],
    associated_against: {
      varients: [:name]
    },
    using: {
      tsearch: { prefix: true }
    }

	mount_uploader :photo, PhotoUploader
end
