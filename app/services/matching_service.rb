class MatchingService

	def initialize
	end

	def product_found(product)
		puts "Checking for product..."
		return Product.where("brand ILIKE ? AND name ILIKE ?", "%#{product[:brand]}%", "%#{product[:name]}%").present?
	end

	def variant_found(variant, product_id)
		puts "Checking for variant..."
		return Varient.where("name ILIKE ? AND product_id = ?", "%#{variant[:name]}%", product_id).present?
	end
end





