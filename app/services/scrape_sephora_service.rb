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
		url = "https://www.sephora.com.au/api/v2.3/products?filter&page[size]=500&page[number]=#{page}&sort=sales&include=variants,brand"
		json_file = open(url, "Accept-Language" => "en-AU").read
		result = JSON.parse(json_file)

		save_product(result)

		p result["data"]
	end

	def save_product(result)
		result["data"].each do |element|

			binding.pry 
			
			product_categories = []

			element["relationships"]["categories"]["data"].each do |category|
				product_categories << @categories[category["id"]]
			end

			@products << {
				source_id: element["id"],
				brand: @brands[element["relationships"]["brand"]["data"]["id"]],
				name: element["attributes"]["name"],
				categories: product_categories,
				rating: element["attributes"]["rating"],
				review_count: element["attributes"]["reviews-count"],
				original_price: element["attributes"]["original-price"],
				price: element["attributes"]["price"],
				web_url: element["attributes"]["web-url"],
				image_urls: element["attributes"]["image-urls"],
				variants_count: element["attributes"]["variants-count"],
			}
		end
	end

	def csv_export
		csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
		filepath    = 'sephora.csv'

		CSV.open(filepath, 'wb', csv_options) do |csv|
		  csv << ['source_id', 'brand', 'name', 'categories', 'price', 'rating', 'review_count', 'original_price', 'web_url', 'image_urls', 'variant_count']
		  @products.each do |product|
		  	csv << [product[:source_id], product[:brand], product[:name], product[:categories], product[:price], product[:rating], product[:review_count], product[:original_price], product[:web_url], product[:image_urls], product[:variants_count]]
		  end
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
		# csv_export
	end

end

ScrapeSephoraService.new.run

