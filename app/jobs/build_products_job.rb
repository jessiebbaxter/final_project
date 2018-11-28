class BuildProductsJob < ApplicationJob
  queue_as :default

  def perform_target
    puts "Adding Target products"
    ScrapeTargetService.new.run
    puts "Finished adding Target products"
  end

  def perform_mecca
    puts "Adding Mecca products"
    ScrapeMeccaService.new.run
    puts "Finished adding Mecca products"
  end
end
