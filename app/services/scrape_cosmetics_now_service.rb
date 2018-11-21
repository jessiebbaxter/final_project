require 'open-uri'
require 'nokogiri'
require 'json'
require 'csv'
require 'pry'

class ScrapeCosmeticsNowService

  def initialize(url, file_path)
    @url = url
    @file_path = file_path
    # @url = "https://www.cosmeticsnow.com.au/s/living-proof"
    @html_doc = open_and_read_doc(@url)
    @products = data_grab(@html_doc)
    @products_array = []
    gather_products_array(@products)
    run(@html_doc)
    save_csv
  end

  def run(html_doc)
    until !set_link_path(html_doc)
      path = set_link_path(html_doc)
      url = set_url(path)
      html_doc = open_and_read_doc(url)
      products = data_grab(html_doc)
      gather_products_array(products)
    end
  end

  private

  def set_url(path)
    return "https://www.cosmeticsnow.com.au#{path}"
  end

  def open_and_read_doc(url)
    html_file = open(url).read
    html_data = Nokogiri::HTML(html_file)
    return html_data
  end

  def set_link_path(html_doc)
    link_element = html_doc.search('a[title*="Next"]')
    if link_element.any?
      path = link_element.attribute('href').value
      return path
    else
      nil
    end
  end

  def data_grab(html_doc)
    # scraping google analytics ecommerce data
    json1 = /ecommerce': (.*)}\)/.match(html_doc)
    products = JSON.parse(json1[1])

    return products
  end

  def gather_products_array(products)
    products["impressions"].each do |product|
      @products_array << product
    end
  end

  def save_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    file_path = @file_path
    CSV.open(file_path, 'wb', csv_options) do |csv|
      csv << ['source_id', 'brand', 'name', 'categories', 'price', 'web_url']
      @products_array.each do |prod|
        web_url = build_web_url(prod["name"])
        name_cleaned = clean_name(prod["name"], prod["brand"])
        csv << [prod["id"], prod["brand"], name_cleaned, prod["category"], prod["price"], web_url]
      end
    end
  end

  def build_web_url(product_name)
    product_info = product_name.gsub(' - ', ' ')
    clean_info = product_info.gsub('-', '%7C-').gsub('&', 'and').gsub('#', 'no').delete('()').delete(',')
    hyphenate_info = clean_info.gsub(' ', '-')
    "https://www.cosmeticsnow.com.au/iteminfo/#{hyphenate_info}"
  end

  def clean_name(product_name, brand)
    name_without_brand = product_name.gsub(/#{brand}\s/, '')
    clean_name = name_without_brand.gsub(/(\(.*)\)\s/, '')
    clean_name.strip
    return clean_name
  end
end

ScrapeCosmeticsNowService.new("https://www.cosmeticsnow.com.au/c/makeup/eyes", 'app/data/cosmetics_now_eyes.csv')
ScrapeCosmeticsNowService.new("https://www.cosmeticsnow.com.au/c/makeup/face", 'app/data/cosmetics_now_face.csv')
ScrapeCosmeticsNowService.new("https://www.cosmeticsnow.com.au/c/makeup/lips", 'app/data/cosmetics_now_lips.csv')
ScrapeCosmeticsNowService.new("https://www.cosmeticsnow.com.au/c/makeup/makeup-sets", 'app/data/cosmetics_now_makeup_sets.csv')
ScrapeCosmeticsNowService.new("https://www.cosmeticsnow.com.au/c/makeup/nails", 'app/data/cosmetics_now_nails.csv')




