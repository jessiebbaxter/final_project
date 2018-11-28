class ScrapeSephoraService

	def initialize
		@seller_id = Seller.find_by(domain: "Sephora").id
		grab_brands
		grab_categories
	end

	def grab_brands
		# brands are stores in seperate API
		puts "Grabbing brand list..."
		url = "https://www.sephora.com.au/api/v2.3/brands?page[size]=500&page[number]=1"
		json_file = open(url, "Accept-Language" => "en-AU").read
		result = JSON.parse(json_file)
		@brands = {}

		result["data"].each do |element|
			@brands[element["id"]] = element["attributes"]["name"]
		end
	end

	def grab_categories
		# cateogires are stored in seperate api
		puts "Grabbing category list..."
		url = "https://www.sephora.com.au/api/v2.4/categories"
		json_file = open(url, "Accept-Language" => "en-AU").read
		result = JSON.parse(json_file)
		@categories = {}

		result["data"].each do |element|
			@categories[element["id"]] = element["attributes"]["label"]
		end
	end

	def grab_products(products_per_page, count)
		puts "Grabbing product list on page #{count} (#{products_per_page} products per page requested - max 500)..."
		url = "https://www.sephora.com.au/api/v2.3/products?filter&page[size]=#{products_per_page}&page[number]=#{count}&sort=sales&include=variants,brand"
		json_file = open(url, "Accept-Language" => "en-AU").read
		result = JSON.parse(json_file)

		create_products(result)
	end

	def create_products(result)

		result["data"].each do |element|
			
			product_categories = []
			element["relationships"]["categories"]["data"].each do |category|
				product_categories << @categories[category["id"]]
			end
			
			brand = @brands[element["relationships"]["brand"]["data"]["id"]]
			name = element["attributes"]["name"]

			product = {
				brand: brand,
				name: name
			}

			product_found = MatchingService.new.product_found(product)

			if product_found == false

				new_product = Product.new(
						name: name,
						category: product_categories,
						brand: brand,
						rating: element["attributes"]["rating"].to_i,
						review_count: element["attributes"]["reviews-count"].to_i
					)

				begin
					new_product.remote_photo_url = element["attributes"]["image-urls"].first
					new_product.save

					puts 'CREATED PRODUCT'

					@product_url = element["attributes"]["web-url"]
					@product_id = Product.last.id

					product_url_id = element["attributes"]["web-url"].gsub("https://www.sephora.com.au/products/", "")
					product_api = "https://www.sephora.com.au/api/v2.1/products/"+"#{product_url_id}"+"?&include=variants,variants.ads,product_articles"
					
					create_variants(product_api)
				rescue
					puts "One product skipped due to image..."
				end
			end
		end
	end

	def create_variants(api)
		begin
			json_file = open(api, "Accept-Language" => "en-AU").read
			result = JSON.parse(json_file)

			if result["included"].nil?
				Product.last.destroy
				puts "Oops. No result from product api, product skipped"
			else
				result["included"].each do |element|

					variant_name = element["attributes"]["name"]

					if variant_name.present?

						variant_found = MatchingService.new.variant_found(variant_name, @product_id)

						if variant_found == false
							new_variant = Varient.new(
									name: element["attributes"]["name"],
									product_id: @product_id
								)
							begin
							new_variant.remote_photo_url = element["attributes"]["image-url"]
							new_variant.save

							puts 'CREATED VARIANT'
							@variant_id = Varient.last.id

							create_inventory(element)
							rescue
								puts "One variant skipped due to image..."
							end
						end
					end
				end
			end
		rescue OpenURI::HTTPError => ex
			Product.last.destroy
      puts "Oops. HTTP error, product skipped"
    end 
	end

	def create_inventory(element)
		
		if !element["attributes"]["slug-url"]
			variant_url = @product_url
		else
			variant_url = @product_url+'/v/'+element["attributes"]["slug-url"]
		end

		puts "Checking if inventory exists..."
		inventory_found = Inventory.where("source_url = ?", "#{variant_url}").present?

		if inventory_found == false
			Inventory.create(
					price: element["attributes"]["price"]/100,
					source_url: variant_url,
					varient_id: @variant_id,
					seller_id: @seller_id 
				)

			puts 'CREATED INVENTORY'
		end
	end

	def run(products_per_page, page_count)
		count = 1
		# Product api displays max 500 items/pg over 7 pages
		if page_count > 7
			page_count = 7
		end
		page_count.times do 
			grab_products(products_per_page, count)
			count += 1
		end
	end
end
