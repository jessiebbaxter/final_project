class ScrapeTargetService

	def initialize
		@seller = "Target"
		@categories_to_parse = [
			# "https://www.target.com.au/c/beauty/shaving-grooming/W298377?N=271z&Nrpp=90&viewAs=grid"
			"https://www.target.com.au/c/beauty/makeup/W1110505?N=28wx&Nrpp=90&viewAs=grid&category=W1110505"
			# "https://www.target.com.au/c/beauty/skincare/W298354?N=2721&Nrpp=90&viewAs=grid",
			# "https://www.target.com.au/c/beauty/bodycare/W298361?N=26ze&Nrpp=90&viewAs=grid"
		]
	end

	def find_seller
		seller = Seller.find_by(domain: @seller)
		@seller_id = seller.id
	end

	def grab_products
		@categories_to_parse.each do |url|
			# First page format is unique
			puts "Grabbing products on page 1..."
			get_product_url(url)
			count = 1
			url = url+"&page=#{count}"
			until final_page?(url)
				puts "Grabbing products on page #{count + 1}..."
				get_product_url(url)
				count += 1
				url = url[0...-1]+"#{count}"
			end
		end
	end

	def get_html_doc(url)
		html_file = open(url, {
			'User-Agent' => 'Mozilla',
		  'Cookie' => 'troute=t1;',
		}).read

		html_doc = Nokogiri::HTML(html_file)
	end

	def final_page?(url)
		 html_doc = get_html_doc(url)
		 html_doc.search('.results-problem').text.include? "Unfortunately"
	end

	def get_product_url(url)
		html_doc = get_html_doc(url)

		product_results = html_doc.search(".name-heading a")

		product_results.each do |link|
			create_product("https://www.target.com.au"+link.attribute('href').value)
		end
	end

	def create_product(url)
		html_doc = get_html_doc(url)
		@product_data = JSON.parse(html_doc.search(".__react_initial_state__").text)
		@seller_product_id = @product_data["entities"]["products"].keys[0]

		product_categories = []
			@product_data["entities"]["products"][@seller_product_id]["categories"].each do |category|
				product_categories << category["name"].downcase
			end

		brand = @product_data["entities"]["products"][@seller_product_id]["brand"]

		new_product = Product.new(
				name: @product_data["entities"]["products"][@seller_product_id]["name"].gsub(/#{brand} /i, ""),
				category: product_categories,
				brand: brand
			)

		product_hero_image = "https://www.target.com.au"+@product_data["entities"]["products"][@seller_product_id]["targetVariantProductListerData"][0]["images"][0]["url"]
		new_product.remote_photo_url = product_hero_image
		new_product.save
		puts "Created product"
		@product_id = Product.last.id
		create_variant
	end

	def create_variant
		variants_data = @product_data["entities"]["products"][@seller_product_id]["targetVariantProductListerData"]

		variants_data.each do |variant|

			if variant["swatchColour"].nil?
				name = "default"
			else
				name = variant["swatchColour"]
			end

			new_variant = Varient.new(
				name: name,
				product_id: @product_id
			) 

			new_variant.remote_photo_url = "https://www.target.com.au"+variant["images"][0]["url"]
			new_variant.save
			puts 'Created variant'
			@variant_id = Varient.last.id
			create_inventory(variant)
		end
	end

	def create_inventory(variant)
		Inventory.create(
				price: variant["price"]["value"],
				source_url: "https://www.target.com.au"+variant["url"],
				varient_id: @variant_id,
				seller_id: @seller_id 
			)
		puts "Created inventory"
	end

	def run
		find_seller
		grab_products
	end

end