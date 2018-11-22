puts 'Cleaning database...'
Inventory.destroy_all
Seller.destroy_all
Varient.destroy_all
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all

puts 'Starting Sephora scrape...'
sephora_scrape = ScrapeSephoraService.new.run
sephora_products = sephora_scrape[0]
sephora_variants = sephora_scrape[1]
puts 'Finished Sephora scrape...'

# Create seller
Seller.create(domain: "Sephora")
puts "Created seller - Sephora"
sephora_seller_id = Seller.last.id

# Create products
sephora_products.each do |product|
	Product.create(brand: product[:brand], name: product[:name], category: product[:categories])
	puts "Created product from Sephora"
	product_id = Product.last.id
	seller_product_id = product[:seller_product_id]
	# Create variants
	product_variants = sephora_variants.select { |element| element[:seller_product_id] == seller_product_id }
	product_variants.each do |variant|
		new_variant = Varient.new(name: variant[:name], product_id: product_id)
		new_variant.remote_photo_url = variant[:img_url]
		new_variant.save
		puts "Created variant from Sephora"
		variant_id = Varient.last.id
		# Create inventory
		new_inventory = Inventory.new(price: variant[:price], source_url: variant[:variant_url], varient_id: variant_id, seller_id: sephora_seller_id)
		new_inventory.remote_photo_url = variant[:img_url]
		new_inventory.save
		puts "Created inventory from Sephora"
	end
end
puts 'Finished!'

# Matching logic
# Match on brand name, match first two words