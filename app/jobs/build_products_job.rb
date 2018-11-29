class BuildProductsJob < ApplicationJob
  queue_as :default

  def perform
    puts "Adding Target products"
    ScrapeTargetService.new.run
    puts "Finished adding Target products"
  end
end
