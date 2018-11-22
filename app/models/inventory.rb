class Inventory < ApplicationRecord
  belongs_to :varient
  belongs_to :seller

  monetize :price_cents

  mount_uploader :photo, PhotoUploader
end
