class Varient < ApplicationRecord
  belongs_to :product
  has_many :inventories, dependent: :destroy

  mount_uploader :photo, PhotoUploader
end
