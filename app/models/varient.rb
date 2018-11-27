class Varient < ApplicationRecord
  belongs_to :product
  has_many :inventories, dependent: :destroy
  has_many :sellers, through: :inventories

  mount_uploader :photo, PhotoUploader
end
