class ScrapeMeccaService

	def initialize
		@seller_id = Seller.find_by(domain: "Mecca").id
		@categories_to_parse = [
			"https://www.mecca.com.au/makeup/#sz=150",
			"https://www.mecca.com.au/skin-care/#sz=150",
			"https://www.mecca.com.au/hair/#sz=150",
			"https://www.mecca.com.au/body/#sz=150"
		]
	end

	def grab_products
		@categories_to_parse.each do |url|
			final_page_start = final_page_start(url)
			size = url.scan(/\d+/).last
			start = size
			# First page format is unique
			get_product_urls(url)
			if start <= final_page_start
				url = url+"&start=#{start}"
				get_product_urls(url)
				start += size
			end
		end
	end

	def get_html_doc(url)
		html_file = open(url, {
			'User-Agent' => 'Mozilla',
		  'Cookie' => 'troute=t1;',
		}).read

		return Nokogiri::HTML(html_file)
	end

	def final_page_start(url)
		 html_doc = get_html_doc(url)
		 final_page = html_doc.search('.page-last')[0]['href']
		 final_page_start = final_page.scan(/\d+/).last 
	end

	def get_product_urls(url)
		product_results = get_html_doc(url).search('.brand-name')

		product_results.each do |product|
			create_product(product['href']) 
		end
	end

	def create_product(url)
		@product_result = get_html_doc(url)

		new_product = Product.new(
			name: @product_result.search('.product-name')[1].text,
			# category: TODO,
			brand: @product_result.search('a .product-brand').text,
			rating: @product_result.search('.visually-hidden span')[4].children.text,
			review_count: @product_result.search('.visually-hidden span')[5].children.text
		)

		# product_hero_image = @product_result.search('.primary-image')
		# new_product.remote_photo_url = TODO
		new_product.save
		puts "Created product"
		@product_id = Product.last.id
		create_variant
	end

	def create_variant
		variants = @product_result.search('.variation-select option')

		variants.each do |variant|
			new_variant = Varient.new(
					name: variant.text.strip,
					product_id: @product_id
				) 

				# new_variant.remote_photo_url = TODO
				# new_variant.save
				puts 'Created variant'
				@variant_id = Varient.last.id
				create_inventory(variant)
		end
	end

	def create_inventory(variant)
		Inventory.create(
				price: @product_result.search('.visually-hidden span')[6]['content'],
				source_url: variant['value'],
				varient_id: @variant_id,
				seller_id: @seller_id 
			)

		puts 'Created inventory'
	end

	def run
		grab_products
	end
end