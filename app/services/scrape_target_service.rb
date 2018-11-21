require 'open-uri'
require 'nokogiri'
require 'pry'
require 'json'
require 'csv'

class ScrapeTargetService

	def initialize
		@products = []
		@product_urls = []
		@variants = []
	end

	# "https://www.target.com.au/c/beauty/makeup/W1110505?N=28wx&Nrpp=90&viewAs=grid&category=W1110505"
	# "https://www.target.com.au/c/beauty/makeup/W1110505?N=28wx&Nrpp=90&viewAs=grid&category=W1110505&page=1"

	def get_product_pg_urls
		categories_to_parse = [
			# "https://www.target.com.au/c/beauty/shaving-grooming/W298377?N=271z&Nrpp=90&viewAs=grid",
			# "https://www.target.com.au/c/beauty/makeup/W1110505?N=28wx&Nrpp=90&viewAs=grid&category=W1110505",
			# "https://www.target.com.au/c/beauty/skincare/W298354?N=2721&Nrpp=90&viewAs=grid",
			# "https://www.target.com.au/c/beauty/bodycare/W298361?N=26ze&Nrpp=90&viewAs=grid"
		]

		categories_to_parse.each do |url|
			# First page format is unique
			get_product_urls(url)
			count = 1
			url = url+"&page=#{count}"
			until final_page?(url)
				get_product_urls(url)
				count += 1
				url = url+"&page=#{count}"
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

	def get_product_urls(url)
		# binding.pry
		html_doc = get_html_doc(url)

		product_results = html_doc.search(".name-heading a")

		product_results.each do |link|
			@product_urls << "https://www.target.com.au"+link.attribute('href').value
		end
	end

	def parse_product_urls
		@product_urls.each do |url|
			html_doc = get_html_doc(url)
			@product_data = JSON.parse(html_doc.search(".__react_initial_state__").text)
			pull_product_info
			pull_varient_info
		end
	end

	def pull_product_info

		@seller_product_id = @product_data["entities"]["products"].keys[0]

		brand = @product_data["entities"]["products"][@seller_product_id]["brand"]

		categories = []
			@product_data["entities"]["products"][@seller_product_id]["categories"].each do |category|
				categories << category["name"].downcase
			end

		@products << {
			brand: brand,
			name: @product_data["entities"]["products"][@seller_product_id]["name"].gsub(/#{brand} /i, "").downcase,
			categories: categories,
			seller_product_id: @seller_product_id
		}
	end

	def pull_varient_info
		variants_data = @product_data["entities"]["products"][@seller_product_id]["targetVariantProductListerData"]

		variants_data.each do |variant|
			@variants << {
				seller_product_id: @seller_product_id,
				source_url: "https://www.target.com.au"+variant["url"],
				name: variant["swatchColour"],
				price: variant["price"]["value"],
			  image_url: "https://www.target.com.au"+variant["images"][0]["url"]
			}
		end
	end

	def run
		get_product_pg_urls
		parse_product_urls
	end

end

ScrapeTargetService.new.run
