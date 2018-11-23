class OrderItem < ApplicationRecord
  belongs_to :inventory
  belongs_to :order
end
