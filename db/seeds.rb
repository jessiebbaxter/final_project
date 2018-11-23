puts 'Cleaning database...'

Inventory.destroy_all
puts 'Removed inventory'

Seller.destroy_all
puts 'Removed sellers'

Varient.destroy_all
puts 'Removed variants'

Product.destroy_all
puts 'Removed products'


puts 'Creating sellers...'

sellers = []
seller_names = ["Mecca", "CosmeticsNow", "AdoreBeauty", "Sephora", "Target"]

seller_names.each do |seller|
	new_seller = Seller.create(domain: seller)
	sellers << new_seller
end

puts 'Creating products...'

data = JSON.load(open("http://makeup-api.herokuapp.com/api/v1/products.json?product_type=eyeshadow"))

data[100...200].each do |product|
	# creating product
	Product.create(brand: product["brand"].capitalize, name: product["name"], category: product["category"])
	puts "Created product"
	if product["product_colors"].empty?
		# creating variant
		product_id = Product.last.id
		new_variant = Varient.new(product_id: product_id, name: "default")
		begin 
			new_variant.remote_photo_url = product["image_link"]
			new_variant.save
			puts "Created variant"
			# creating inventory
			variant_id = Varient.last.id
			new_inventory = Inventory.new(price: product["price"], varient_id: variant_id, seller_id: sellers.sample.id)
			new_inventory.remote_photo_url = product["image_link"]
			new_inventory.save
			puts "Created inventory"
		rescue
			Product.last.destroy
			puts "Oops. Error with photo, product skipped"
		end
	else
		product["product_colors"].each do |color|
			# creating variant
			product_id = Product.last.id
			new_variant = Varient.new(product_id: product_id, name: color["colour_name"])
			begin 
				new_variant.remote_photo_url = product["image_link"]
				new_variant.save
				puts "Created variant"
				# creating inventory
				variant_id = Varient.last.id
				new_inventory = Inventory.new(price: product["price"], varient_id: variant_id, seller_id: sellers.sample.id)
				new_inventory.remote_photo_url = product["image_link"]
				new_inventory.save
				puts "Created inventory"
			rescue
				Product.last.destroy
				puts "Oops. Error with photo, product skipped"
			end
		end
	end
end

puts 'Finished!'

# --------------------------

# puts 'Creating master users...'

# lisa = User.create(email: "lisa@beautynb.com.au", password: "password")
# caroline = User.create(email: "caroline@beautynb.com.au", password: "password")
# jessie = User.create(email: "jessie@beautynb.com.au", password: "password")

# users = [
# 	lisa,
# 	caroline,
# 	jessie
# ]

# puts 'Creating orders...'

# orders = []

# 20.times do
# 	order = Order.create(user_id: users.sample.id, state: "complete")
# 	orders << order
# end

# puts 'Adding items to orders...'

# 30.times do 
# 	OrderItem.create(product_id: products.sample.id, order_id: orders.sample.id, qty: rand(1...4))
# end