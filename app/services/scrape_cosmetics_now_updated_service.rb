
require 'open-uri'
require 'nokogiri'
require 'json'
require 'csv'
require 'pry'

class ScrapeCosmeticsNowUpdatedService

  def initialize(url, file_path)
    @url = url
    @file_path = file_path
    @html_doc = open_and_read_doc(url)
    @products_array = []
    data_grab(@html_doc)
    run(@html_doc)
    save_csv
  end

  def run(html_doc)
    until !set_link_path(html_doc)
      path = set_link_path(html_doc)
      url = set_url(path)
      html_doc = open_and_read_doc(url)
      data_grab(html_doc)
    end
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

  def set_url(path)
    return "https://www.cosmeticsnow.com.au#{path}"
  end


  def data_grab(html_doc)
    product_info = html_doc.search('li[class*="productListing"]')

    product_info.each do |prod|
      @products_array << {
        price: prod.search('span .price').children.text.delete('$.'),
        web_url: prod.children.search('a').attribute('href').value,
        img_url: prod.children.search('a').children[0].attribute('src').value
      }
      # product_name = prod.children.search('a').children[0].attribute('title').value
    end
  end

  def save_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open(@file_path, 'wb', csv_options) do |csv|
      csv << ['price', 'web_url', 'img_url']
      @products_array.each do |prod|
        csv << [prod[:price], prod[:web_url], prod[:img_url]]
      end
    end
  end
end

ScrapeCosmeticsNowUpdatedService.new("https://www.cosmeticsnow.com.au/c/makeup/eyes", 'app/data/cosmetics_now_eyes2.csv')
ScrapeCosmeticsNowUpdatedService.new("https://www.cosmeticsnow.com.au/c/makeup/face", 'app/data/cosmetics_now_face2.csv')
ScrapeCosmeticsNowUpdatedService.new("https://www.cosmeticsnow.com.au/c/makeup/lips", 'app/data/cosmetics_now_lips2.csv')
ScrapeCosmeticsNowUpdatedService.new("https://www.cosmeticsnow.com.au/c/makeup/makeup-sets", 'app/data/cosmetics_now_makeup_sets2.csv')
ScrapeCosmeticsNowUpdatedService.new("https://www.cosmeticsnow.com.au/c/makeup/nails", 'app/data/cosmetics_now_nails2.csv')
