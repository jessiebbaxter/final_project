def MatchingService

	def initialize
	end

	def product_not_found?(product)
		puts "Checking if product is found..."
		return Product.where("brand ILIKE ? AND name ILIKE ?", "%#{product[:brand]}%", "%#{product[:name]}%").nil?
	end

	def variant_not_found?(variant, product_id)
		puts "Checking if variant is found..."
		return Varient.where("name ILIKE ? AND product_id = ?", "%#{variant[:name]}%", product_id).nil?
	end
end




