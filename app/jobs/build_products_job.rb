class BuildProductsJob < ApplicationJob
  queue_as :default

  def perform
    puts "Adding Mecca products"
    ScrapeMeccaService.new.run
    puts "Finished adding Mecca products"

    puts "Adding Target products"
    ScrapeTargetService.new.run
    puts "Finished adding Target products"
  end
end
