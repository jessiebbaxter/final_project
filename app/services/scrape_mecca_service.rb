require 'pry'

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

		brand = @product_result.search('a .product-brand').text
		name = @product_result.search('.product-name')[1].text

		product = {
			brand: brand,
			name: name
		}

		product_found = MatchingService.new.product_found(product)

		if product_found == false
			new_product = Product.new(
				name: name,
				# category: TODO,
				brand: brand,
				rating: @product_result.search('.visually-hidden span')[4].children.text,
				review_count: @product_result.search('.visually-hidden span')[5].children.text
			)

			product_hero_image = @product_result.search('.primary-image').attr('src').value
			new_product.remote_photo_url = "https://www.mecca.com.au"+product_hero_image
			new_product.save
			puts "Created product"
			@product_id = Product.last.id
			create_variant
		else
			@product_id = Product.where("brand ILIKE ? AND name ILIKE ?", "%#{brand}%", "%#{name}%")[0].id
			create_variant	
		end
	end

	def create_variant
		binding.pry
		variants = @product_result.search('.variation-select option')

		# IF VARIANTS IS FALSE - ADD DEFAULT VARIANT

		variants.each do |variant|

			variant_name = variant.text.strip
			variant_found = MatchingService.new.variant_found(variant_name, @product_id)

			if variant_found == false
				new_variant = Varient.new(
						name: variant_name,
						product_id: @product_id
					) 

				json_img_file = variant.attr('data-lgimg')
				result = JSON.parse(json_img_file)
				variant_photo = result["url"]

				new_variant.remote_photo_url = "https://www.mecca.com.au"+variant_photo
				new_variant.save
				puts 'Created variant'
				@variant_id = Varient.last.id
				create_inventory(variant)
			else
				@variant_id = Varient.where("name ILIKE ? AND product_id = ?", "%#{name}%", @product_id)[0].id
				create_inventory(variant)
			end
		end
	end

	def create_inventory(variant)
		source_url = variant['value']

		inventory_found = Inventory.where("source_url = ?", "#{source_url}").present?

		if inventory_found == false
			Inventory.create(
					price: @product_result.search('.visually-hidden span')[6]['content'],
					source_url: source_url,
					varient_id: @variant_id,
					seller_id: @seller_id 
				)

			puts 'Created inventory'
		end
	end

	def run
		grab_products
	end
end