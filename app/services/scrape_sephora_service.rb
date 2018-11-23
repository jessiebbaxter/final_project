require 'open-uri'
require 'nokogiri'
# require 'pry'
require 'json'
require 'csv'

class ScrapeSephoraService

	def initialize
		@brands = {}
		@categories = {}
		@products = []
		@variants = []
	end

	def grab_brands
		url = "https://www.sephora.com.au/api/v2.3/brands?page[size]=500&page[number]=1"
		json_file = open(url, "Accept-Language" => "en-AU").read
		result = JSON.parse(json_file)

		result["data"].each do |element|
			@brands[element["id"]] = element["attributes"]["name"]
		end
		return @brands
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
		url = "https://www.sephora.com.au/api/v2.3/products?filter&page[size]=1&page[number]=#{page}&sort=sales&include=variants,brand"
		json_file = open(url, "Accept-Language" => "en-AU").read
		result = JSON.parse(json_file)

		build_products_variants(result)
	end

	def build_products_variants(result)

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
			
			json_file = open(product_api, "Accept-Language" => "en-AU").read
			result = JSON.parse(json_file)

			result["included"].each do |element|

				if !element["attributes"]["slug-url"]
					variant_url = @products.last[:web_url]
				else
					variant_url = @products.last[:web_url]+'/v/'+element["attributes"]["slug-url"]
				end

				@variants << {
					seller_product_id: @products.last[:source_id],
					name: element["attributes"]["name"],
					img_url: element["attributes"]["image-url"],
					original_price: element["attributes"]["original-price"],
					price: element["attributes"]["price"],
					variant_url: variant_url
				}
			end

		end
	end

	# def csv_export
	# 	csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
	# 	filepath    = 'sephora.csv'

	# 	CSV.open(filepath, 'wb', csv_options) do |csv|
	# 	  csv << ['source_id', 'brand', 'name', 'categories', 'price', 'rating', 'review_count', 'original_price', 'web_url', 'image_urls', 'variant_count']
	# 	  @products.each do |product|
	# 	  	csv << [product[:source_id], product[:brand], product[:name], product[:categories], product[:price], product[:rating], product[:review_count], product[:original_price], product[:web_url], product[:image_urls], product[:variants_count]]
	# 	  end
	# 	end
	# end

	def run
		grab_brands
		grab_categories
		page = 1
		# Product api displays 500 items/pg over 7 pages
		7.times do 
			grab_products(page)
			page += 1
		end
		# csv_export
	end

end

ScrapeSephoraService.new.run

