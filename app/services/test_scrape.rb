require 'open-uri'
require 'nokogiri'
# require 'pry'
require 'json'

url = "https://www.mecca.com.au/nars/sheer-glow-foundation/V-006868.html?cgpath=makeup#sz=150&start=1"

html_file = open(url, {
	'User-Agent' => 'Mozilla',
  'Cookie' => 'troute=t1;',
}).read

html_doc = Nokogiri::HTML(html_file)

p html_doc.search('.price-sales').text.gsub(/\s+/, "").gsub("$", "").to_i
# result = JSON.parse(json_file)
# p result["url"]

# product_hero_image = @product_result.search('.primary-image').attr('src').value

# url = "https://www.target.com.au/p/chi-chi-eyeshadow-palette/61833173"

# html_file = open(url, {
# 	'User-Agent' => 'Mozilla',
#   'Cookie' => 'troute=t1;',
# }).read

# html_doc = Nokogiri::HTML(html_file)

# product_data = JSON.parse(html_doc.search(".__react_initial_state__").text)
# seller_product_id = product_data["entities"]["products"].keys[0]

# p product_data["entities"]["lookData"][0]["collectionName"]