class Inventory < ApplicationRecord
  belongs_to :varient
  belongs_to :seller

end
