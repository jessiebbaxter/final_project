puts 'Cleaning database...'
Inventory.destroy_all
puts 'Removed inventory'

Seller.destroy_all
puts 'Removed sellers'

Varient.destroy_all
puts 'Removed variants'

Product.destroy_all
puts 'Removed products'

puts 'Starting Sephora scrape...'

ScrapeSephoraService.new.run(5, 1)

puts 'Finished Sephora scrape...'

puts 'Finished seed!'