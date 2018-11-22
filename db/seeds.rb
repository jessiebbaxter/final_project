# puts 'Cleaning database...'

# Varient.destroy_all
# OrderItem.destroy_all
# Order.destroy_all
# Product.destroy_all

puts 'Creating Sephora products and variants...'

sephora_scrape = ScrapeSephoraService.new.run
sephora_products = sephora_scrape[0]
sephora_variants = sephora_scrape[1]

sephora_products.each do |product|
	Product.create(brand: product[:brand], name: product[:name], category: product[:categories])
	product_id = Product.last.id
	seller_product_id = product[:seller_product_id]
	binding.pry
	product_variants = sephora_variants.select { |element| element[:seller_product_id] == seller_product_id }
	product_variants.each do |variant|
		new_variant = Varient.new(name: variant[:name], product_id: product_id)
		binding.pry
		new_variant.remote_photo_url = variant[:img_url]
		new_variant.save
		# create inventory items - can't remember how to do price
	end
end

puts 'Finished!'

# POTENTIAL BUGS
# Seems to be creating multiple variants

# t.string "source_url"
# t.string "image_url"
# t.integer "price_cents", default: 0, null: false
# t.bigint "varient_id"
# t.bigint "seller_id"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.string "photo"