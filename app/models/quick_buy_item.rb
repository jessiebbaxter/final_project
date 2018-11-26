class QuickBuyItem < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :inventory

  validates :user_id, presence: true
  validates :product_id, presence: true
end
