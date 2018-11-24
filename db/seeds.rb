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