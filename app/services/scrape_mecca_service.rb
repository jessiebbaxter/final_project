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

	# URL format: 
	# https://www.mecca.com.au/makeup/#sz=150 <-- first page of results
	# https://www.mecca.com.au/makeup/#sz=150&start=150 <-- 2nd page of results

	def get_product_pg_urls
		categories_to_parse = [
			"https://www.mecca.com.au/makeup/#sz=150"
			#add more categories here
		]

		categories_to_parse.each do |url|
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

		html_doc = Nokogiri::HTML(html_file)
	end

	def final_page_start(url)
		 html_doc = get_html_doc(url)
		 final_page = html_doc.search('.page-last')[0]['href']
		 final_page_start = final_page.scan(/\d+/).last 
	end

	def get_product_urls(url)
		# binding.pry
		html_doc = get_html_doc(url)

		product_results = html_doc.search('.brand-name')

		product_results.each do |element|
			@product_urls << element['href']
		end

		# TO DO: Count of @product_urls is 36 when it should be 150
	end

	def parse_product_urls
		@product_urls.each do |url|
			html_doc = get_html_doc(url)
			build_products_variants(html_doc)
		end
	end

	# FOR SEED: pass in html_doc (not url) for final piece
	def build_products_variants(url)
		html_file = open(url, {
			'User-Agent' => 'Mozilla',
		  'Cookie' => 'troute=t1;',
		}).read

		html_doc = Nokogiri::HTML(html_file)

		@products << {
			web_url: url,
			brand: html_doc.search('a .product-brand').text,
			name: html_doc.search('.product-name')[1].text,
			seller_product_id: html_doc.search('.visually-hidden span')[0].children.text,
			rating: html_doc.search('.visually-hidden span')[4].children.text,
			review_count: html_doc.search('.visually-hidden span')[5].children.text,
			price: html_doc.search('.visually-hidden span')[6]['content']
			# category: TODO
		}

		variant_options = html_doc.search('.variation-select option')

		variant_options.each do |option|
			@variants << {
				seller_product_id: html_doc.search('.visually-hidden span')[0].children.text,
				variant_url: option['value'],
				# image_url: TODO
				name: option.text.strip,
				price: html_doc.search('.visually-hidden span')[6]['content']
			}
		end
		
		p html_doc.search('.variation-select option')[0]
		# TODO: Add categories and image_urls, update this method & test

	end

	def run
		get_product_pg_urls
		parse_product_urls
	end

end

ScrapeTargetService.new.build_products_variants("https://www.mecca.com.au/stila/magnificent-metals-glitter-glow-liquid-eye-shadow/V-026663.html?cgpath=makeup")
