require 'google/api_client/client_secrets.rb'
require 'google/apis/gmail_v1'

class GmailSearcherController < ApplicationController

  def get_messages
    # Initialize Google Calendar API
    service = Google::Apis::GmailV1::GmailService.new
    # Use google keys to authorize
    service.authorization = google_secret.to_authorization
    # Request for a new aceess token just incase it expired
    # service.authorization.refresh!
    # Get a list of calendars
    varient = Varient.find(11583)
    product = Product.find_by(varient_id: varient.id)
    inventory_list = []
    if messages_list = service.list_user_messages(current_user.email, q: product.name).messages
      inventory_list << varient
    end
    inventory_list << Varient.find(2703)
    inventory_list << Varient.find(3877)
    inventory_list.each do |item|
      product = item.inventories.first
      @quick_buy = QuickBuyItem.create(inventory_id: product.id, product_id: item.product_id, user_id: current_user.id)
    end

    redirect_to root_path
    flash[:notice] = "#{inventory_list.count} products have been found and added to your Quick Buys"
  end

private
  def google_secret
    Google::APIClient::ClientSecrets.new(
      { "web" =>
        { "access_token" => current_user.google_token,
          "refresh_token" => current_user.google_refresh_token,
          "client_id" => Rails.application.secrets.google_client_id,
          "client_secret" => Rails.application.secrets.google_client_secret,
        }
      }
    )
  end
end
