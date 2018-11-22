require 'open-uri'
require 'nokogiri'
require 'pry'
require 'json'
require 'csv'

class ScrapeSephoraService

	def initialize
		@brands = {}
		@categories = {}
		@products = []
		@variants = []
		run
	end

	def grab_brands
		# size limit per page is 500
		url = "https://www.sephora.com.au/api/v2.3/brands?page[size]=500&page[number]=1"
		json_file = open(url, "Accept-Language" => "en-AU").read
		result = JSON.parse(json_file)

		result["data"].each do |element|
			@brands[element["id"]] = element["attributes"]["name"]
		end
	end

	def grab_categories
		url = "https://www.sephora.com.au/api/v2.4/categories"
		json_file = open(url, "Accept-Language" => "en-AU").read
		result = JSON.parse(json_file)

		result["data"].each do |element|
			@categories[element["id"]] = element["attributes"]["label"]
		end
		return @categories
	end

	def grab_products(page)
		url = "https://www.sephora.com.au/api/v2.3/products?filter&page[size]=500&page[number]=#{page}&sort=sales&include=variants,brand"
		json_file = open(url, "Accept-Language" => "en-AU").read
		result = JSON.parse(json_file)

		build_products(result)
	end

	def build_products(result)

		result["data"].each do |element|
			
			product_categories = []

			element["relationships"]["categories"]["data"].each do |category|
				product_categories << @categories[category["id"]]
			end

			brand = @brands[element["relationships"]["brand"]["data"]["id"]]
			product_name = element["attributes"]["name"]

			@products << {
				seller_product_id: element["id"],
				brand: @brands[element["relationships"]["brand"]["data"]["id"]],
				name: element["attributes"]["name"],
				categories: product_categories,
				rating: element["attributes"]["rating"],
				review_count: element["attributes"]["reviews-count"],
				web_url: element["attributes"]["web-url"],
				variants_count: element["attributes"]["variants-count"],
			}

			product_url_id = element["attributes"]["web-url"].gsub("https://www.sephora.com.au/products/", "")
			product_api = "https://www.sephora.com.au/api/v2.1/products/"+"#{product_url_id}"+"?&include=variants,variants.ads,product_articles"
			
			build_variants(product_api)
		end
	end

	def build_variants(api)
		begin
			json_file = open(api, "Accept-Language" => "en-AU").read
			result = JSON.parse(json_file)

			if result["included"].nil?
				@products.slice!(-1)
				puts "Oops. No api result, product skipped"
			else
				result["included"].each do |element|

					if !element["attributes"]["slug-url"]
						variant_url = @products.last[:web_url]
					else
						variant_url = @products.last[:web_url]+'/v/'+element["attributes"]["slug-url"]
					end

					@variants << {
						seller_product_id: @products.last[:seller_product_id],
						name: element["attributes"]["name"],
						img_url: element["attributes"]["image-url"],
						original_price: element["attributes"]["original-price"],
						price: element["attributes"]["price"],
						variant_url: variant_url
					}
				end
			end
		rescue OpenURI::HTTPError => ex
			@products.slice!(-1)
      puts "Oops. HTTP error, product skipped"
    end 
	end

	def run
		grab_brands
		grab_categories
		page = 1
		# Product api displays 500 items/pg over 7 pages
		7.times do 
			grab_products(page)
			page += 1
		end
		@scrape = [
			@products,
			@variants
		]
	end
end
