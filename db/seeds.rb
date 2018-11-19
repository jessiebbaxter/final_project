require 'open-uri'
require 'json'

puts 'Cleaning database...'

QuickBuyItem.destroy_all
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
User.destroy_all

puts 'Creating master users...'

lisa = User.create(email: "lisa@beautynb.com.au", password: "password")
caroline = User.create(email: "caroline@beautynb.com.au", password: "password")
jessie = User.create(email: "jessie@beautynb.com.au", password: "password")

users = [
	lisa,
	caroline,
	jessie
]

puts 'Creating products...'

data = JSON.load(open("https://makeup-api.herokuapp.com/api/v1/products.json"))

products = []
random_price = [19, 25, 29, 35, 15, 21, 28, 32]

data[0...10].each do |product|
	if product["price"].to_i < 10
		product["price"] = random_price.sample
		new_product = Product.new(brand: product["brand"].capitalize, name: product["name"], description: product["description"], price: product["price"].to_i, category: product["category"])
		begin 
			new_product.remote_photo_url = product["image_link"]
			new_product.save
			products << new_product
		rescue
			puts "One product skipped due to image..."
		end
	else
		new_product = Product.new(brand: product["brand"].capitalize, name: product["name"], description: product["description"], price: product["price"].to_i, category: product["category"])
		begin 
			new_product.remote_photo_url = product["image_link"]
			new_product.save
			products << new_product
		rescue
			puts "One product skipped due to image..."
		end
	end
end

puts 'Creating orders...'

orders = []

20.times do
	order = Order.create(user_id: users.sample.id, state: "complete")
	orders << order
end

puts 'Adding items to orders...'

30.times do 
	OrderItem.create(product_id: products.sample.id, order_id: orders.sample.id, qty: rand(1...4))
end

puts 'Finished!'