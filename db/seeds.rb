puts 'Cleaning database...'

puts 'Removing inventory...'
Inventory.destroy_all
puts 'Removed inventory'

puts 'Removing sellers...'
Seller.destroy_all
puts 'Removed sellers'

puts 'Removing variants...'
Varient.destroy_all
puts 'Removed variants'

puts 'Removing products...'
Product.destroy_all
puts 'Removed products'

puts 'Creating sellers...'
sellers = ["Target", "Sephora", "Mecca", "Cosmetics Now"]
sellers.each do |seller|
	Seller.create(domain: seller)
	puts "Created seller: #{seller}"
end

puts 'Starting Sephora scrape...'

ScrapeSephoraService.new.run(500, 7)

puts 'Finished Sephora scrape...'

puts 'Finished seed!'

# if you stop the seed to save time from a long scrape,
# comment out everything above this comment and run the seed
# on just the below lines.

puts 'Adding Shipping Guidelines...'

target = Seller.find_by(domain: "Target")
sephora = Seller.find_by(domain: "Sephora")
mecca = Seller.find_by(domain: "Mecca")
cosmetics_now = Seller.find_by(domain: "Cosmetics Now")


Shipping.create!(
  minimum_spend: 0,
  shipping_speed: 5,
  rule: "2 - 5 business days",
  cost_cents: 12,
  seller_id: sephora.id
  )

Shipping.create!(
  minimum_spend: 0,
  shipping_speed: 8,
  rule: "3 - 8 business days",
  cost_cents: 5,
  seller_id: sephora.id
  )

Shipping.create!(
  minimum_spend: 55,
  shipping_speed: 8,
  rule: "3 - 8 business days",
  cost_cents: 0,
  seller_id: sephora.id
  )

Shipping.create!(
  minimum_spend: 55,
  shipping_speed: 5,
  rule: "2 - 5 business days",
  cost_cents: 7,
  seller_id: sephora.id
  )

puts 'Finished Sephora'

Shipping.create!(
  minimum_spend: 0,
  shipping_speed: 9,
  rule: "5 - 9 business days",
  cost_cents: 9,
  seller_id: target.id
  )

Shipping.create!(
  minimum_spend: 80,
  shipping_speed: 9,
  rule: "5 - 9 business days",
  cost_cents: 0,
  seller_id: target.id
  )

puts 'Finished Target'

Shipping.create!(
  minimum_spend: 0,
  shipping_speed: 4,
  rule: "2 - 4 business days",
  cost_cents: 10,
  seller_id: mecca.id
  )

Shipping.create!(
  minimum_spend: 75,
  shipping_speed: 2,
  rule: "1 - 2 business days",
  cost_cents: 0,
  seller_id: mecca.id
  )
puts 'Finished Mecca'

Shipping.create!(
  minimum_spend: 0,
  shipping_speed: 4,
  rule: "2 - 4 business days",
  cost_cents: 0,
  seller_id: cosmetics_now.id
  )

Shipping.create!(
  minimum_spend: 0,
  shipping_speed: 2,
  rule: "1 - 2 business days",
  cost_cents: 4,
  seller_id: cosmetics_now.id
  )

puts 'Finished Shipping'
