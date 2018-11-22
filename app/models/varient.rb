class Varient < ApplicationRecord
  belongs_to :product
  has_many :inventories

  mount_uploader :photo, PhotoUploader
end
