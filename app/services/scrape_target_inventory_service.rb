class ScrapeTargetInventoryService

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
			update_inventory("https://www.target.com.au"+link.attribute('href').value)
		end
	end

	def update_inventory(url)
		html_doc = get_html_doc(url)
		product_data = JSON.parse(html_doc.search(".__react_initial_state__").text)
		seller_product_id = product_data["entities"]["products"].keys[0]
		variant_data = product_data["entities"]["products"][seller_product_id]["targetVariantProductListerData"]
		
		variant_data.each do |variant|
			source_url = "https://www.target.com.au"+variant["url"]
			inventory_item = Inventory.find_by(source_url: source_url)
			inventory_item.price = variant["price"]["value"]
		end
	end

	def run
		grab_products
	end

end