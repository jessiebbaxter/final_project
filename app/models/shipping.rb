class Shipping < ApplicationRecord
  belongs_to :seller
  monetize :cost_cents
end
