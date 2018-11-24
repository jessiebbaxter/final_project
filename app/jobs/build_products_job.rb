class BuildProductsJob < ApplicationJob
  queue_as :default

  def perform
    puts "Adding Target products"
    ScrapeTargetService.new.run
  end
end
