# puts "Creating 2 new Sellers"

# adore_beauty = Seller.create(domain: "Adore Beauty")
# look_fantastic = Seller.create(domain: "Look Fantastic")

# puts "Assigning Shipping rules to Adore Beauty"

# Shipping.create!(
#   minimum_spend: 0,
#   shipping_speed: 5,
#   rule: "2 - 5 business days",
#   cost: 12,
#   seller_id: adore_beauty.id
#   )

# Shipping.create!(
#   minimum_spend: 0,
#   shipping_speed: 8,
#   rule: "3 - 8 business days",
#   cost: 5,
#   seller_id: adore_beauty.id
#   )

# Shipping.create!(
#   minimum_spend: 25,
#   shipping_speed: 8,
#   rule: "3 - 8 business days",
#   cost: 0,
#   seller_id: adore_beauty.id
#   )

# Shipping.create!(
#   minimum_spend: 25,
#   shipping_speed: 5,
#   rule: "2 - 5 business days",
#   cost: 7,
#   seller_id: adore_beauty.id
#   )

# puts "Assigning Shipping rules to Look Fantastic"

# Shipping.create!(
#   minimum_spend: 0,
#   shipping_speed: 9,
#   rule: "5 - 9 business days",
#   cost: 9,
#   seller_id: look_fantastic.id
#   )

# Shipping.create!(
#   minimum_spend: 80,
#   shipping_speed: 9,
#   rule: "5 - 9 business days",
#   cost: 0,
#   seller_id: look_fantastic.id
#   )

puts "Assigning new inventory items"

inventories = Inventory.all

price_diff = [-300, -200, -100, 0, 100, 200, 300]
sellers = Seller.all

5.times do 
  random_inventory = inventories.sample
  seller_id = random_inventory.seller_id
  remaining_sellers = sellers.reject { |seller| seller.id == seller_id }
  price = random_inventory.price_cents
  variant_id = random_inventory.varient_id
  rand_source_url = (rand 30000...90000000).to_s
  Inventory.create!(source_url: rand_source_url, price_cents: (price + price_diff.sample), varient_id: variant_id, seller_id: remaining_sellers.sample.id)
end

puts "Finished adding new inventory items"

# puts "Creating new coupons"

# existing_coupon_seller_id = Coupon.last.seller_id
# remaining_sellers = sellers.reject { |seller| seller.id == existing_coupon_seller_id }

# rand_discount = [0.1, 0.15, 0.2]

# remaining_sellers.each do |seller|
#   Coupon.create(seller_id: seller.id, discount: rand_discount.sample)
# end

# puts "Applying coupons randomly to inventory"

# coupons = Coupon.all
# inventories_new = Inventory.all

# 10.times do
#   inventory = inventories.sample
#   inventory.coupon_id = coupons.sample.id
#   inventory.save
# end

puts "Finished seed!"
