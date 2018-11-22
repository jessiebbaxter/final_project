require 'open-uri'
require 'json'

puts 'Cleaning database...'

# Inventory.destroy_all
Varient.destroy_all
# QuickBuyItem.destroy_all
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
# User.destroy_all

# puts 'Creating master users...'

# lisa = User.create(email: "lisa@beautynb.com.au", password: "password")
# caroline = User.create(email: "caroline@beautynb.com.au", password: "password")
# jessie = User.create(email: "jessie@beautynb.com.au", password: "password")

# users = [
# 	lisa,
# 	caroline,
# 	jessie
# ]

puts 'Creating products...'

data = JSON.load(open("http://makeup-api.herokuapp.com/api/v1/products.json?brand=covergirl&product_type=foundation"))

products = []
variants = []

data[0...20].each do |product|
	new_product = Product.new(brand: product["brand"].capitalize, name: product["name"], category: product["category"])
	new_product.save
	products << new_product
end

puts 'Creating variants...'

data[0...5].each do |product|

	#TODO: Seed is breaking with 'default' below
	product["product_colors"].each do |variant|
		if variant == []
			new_variant = Varient.new(name: "default", product_id: products.sample.id)
			new_variant.save
			variants << new_variant
		else
			new_variant = Varient.new(name: variant["colour_name"], product_id: products.sample.id)
			new_variant.save
			variants << new_variant
		end
	end

	variants.each do |variant|
		begin
			variant.remote_photo_url = data.sample["image_link"]
			variant.save
			# binding.pry
		rescue
			puts "One product skipped due to image..."
		end
	end
end

# Variants: product_id, name, photo

# --------------------------

# random_price = [19, 25, 29, 35, 15, 21, 28, 32]

# data[0...10].each do |product|
# 	if product["price"].to_i < 10
# 		product["price"] = random_price.sample
# 		new_product = Product.new(brand: product["brand"].capitalize, name: product["name"], description: product["description"], price: product["price"].to_i, category: product["category"])
# 		begin 
# 			new_product.remote_photo_url = product["image_link"]
# 			new_product.save
# 			products << new_product
# 		rescue
# 			puts "One product skipped due to image..."
# 		end
# 	else
# 		new_product = Product.new(brand: product["brand"].capitalize, name: product["name"], description: product["description"], price: product["price"].to_i, category: product["category"])
# 		begin 
# 			new_product.remote_photo_url = product["image_link"]
# 			new_product.save
# 			products << new_product
# 		rescue
# 			puts "One product skipped due to image..."
# 		end
# 	end
# end

# --------------------------

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

puts 'Finished!'