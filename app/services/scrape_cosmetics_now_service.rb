require 'open-uri'
require 'nokogiri'
require 'json'
require 'csv'
# require 'pry'

# Image URL isn't working
# Need to add prefix to web_url

class ScrapeCosmeticsNowService

  def initialize(url)
    @url = url
    @google_analytics_commerce_products_array = []
    @product_listings_array = []
    @combined_products_array = []
    run
  end

  def run
    open_and_read_doc(@url)
    data_grab(@html_doc)
    gather_products_array(@google_analytics_commerce_products)
    build_product_hashes
    additional_data_grab(@html_doc)
    while !get_link_url(@html_doc)
      @url = get_link_url(@html_doc)
      run
    end
    merge_product_arrays
    @combined_products_array[0..10]
  end
  # Get data

  def open_and_read_doc(url)
    html_file = open(url).read
    @html_doc = Nokogiri::HTML(html_file)
  end

  def get_link_url(html_doc)
    link_element = html_doc.search('a[title*="Next"]')
    if link_element.any?
      path = link_element.attribute('href').value
      "https://www.cosmeticsnow.com.au#{path}"
    else
      nil
    end
  end

  def data_grab(html_doc)
    # scraping google analytics ecommerce data
    json1 = /ecommerce': (.*)}\)/.match(html_doc)
    @google_analytics_commerce_products = JSON.parse(json1[1])
  end

  def additional_data_grab(html_doc)
    product_info = html_doc.search('li[class*="productListing"]')
    product_info.each do |prod|
      @product_listings_array << {
        price: prod.search('span .price').children.text.delete('$.'),
        web_url: prod.children.search('a').attribute('href').value,
        img_url: prod.children.search('a').children[0].attribute('src').value
      }
    end
  end
  # to get data you need to go through each page,
  # this function locates the link to the next page

  # merge data
  # gather_products_array(products)
  def gather_products_array(products)
    products["impressions"].each do |product|
      @google_analytics_commerce_products_array << product
    end
  end
  # build_product_hashes
  def build_product_hashes
    @google_analytics_commerce_products_array.each do |prod|
    name_cleaned = clean_name(prod["name"], prod["brand"])
    name_separated = name_cleaned.split(' - ')
    @combined_products_array << {
      brand: prod["brand"],
      name: name_separated[0],
      varient_name: name_separated[1],
      category: create_category_array(prod["category"])
    }
    end
  end

  def merge_product_arrays
    @product_listings_array.each_with_index do |prod, index|
      @combined_products_array[index][:price] = prod[:price]
      @combined_products_array[index][:web_url] = build_product_url(prod[:web_url])
      @combined_products_array[index][:img_url] = "https:#{prod[:img_url]}"
    end
  end

  # clean data

  def clean_name(product_name, brand)
    name_without_brand = product_name.gsub(/#{brand}\s/, '')
    clean_name = name_without_brand.gsub(/(\(.*)\)\s/, '')
    clean_name.strip
  end

  def create_category_array(category_string)
    category_string.split(' >> ')
  end

  def build_product_url(web_url)
    "https://www.cosmeticsnow.com.au#{web_url}"
  end
end

# below are links you can run this code on, you can also
# go grab additional links like hair care if you want additional products

ScrapeCosmeticsNowService.new("https://www.cosmeticsnow.com.au/c/makeup/eyes")
# ScrapeCosmeticsNowService.new("https://www.cosmeticsnow.com.au/c/makeup/face")
# ScrapeCosmeticsNowService.new("https://www.cosmeticsnow.com.au/c/makeup/lips")
# ScrapeCosmeticsNowService.new("https://www.cosmeticsnow.com.au/c/makeup/makeup-sets")
# ScrapeCosmeticsNowService.new("https://www.cosmeticsnow.com.au/c/makeup/nails")

