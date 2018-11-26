require 'pry'

class MatchingService

	def initialize
	end

	def product_found(product)
		puts "Checking if product exists..."
		return Product.where("brand ILIKE ? AND name ILIKE ?", "%#{product[:brand]}%", "%#{product[:name]}%").present?
	end

	def variant_found(variant_name, product_id)
		puts "Checking if variant exists..."
		return Varient.where("name ILIKE ? AND product_id = ?", "%#{variant_name}", "#{product_id}").present?
	end
end





