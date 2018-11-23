puts 'Cleaning database...'
Inventory.destroy_all
Seller.destroy_all
Varient.destroy_all
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all

puts 'Starting Sephora scrape...'
ScrapeSephoraService.new.run(5, 1)
puts 'Finished Sephora scrape...'

puts 'Finished seed!'