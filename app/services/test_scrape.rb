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

p html_doc.search('.primary-image')
