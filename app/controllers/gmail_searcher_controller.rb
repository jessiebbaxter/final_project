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
    messages_list = service.list_user_messages(current_user.email, q: 'asdfasdfasdfasdfasfasdfa').messages
    raise
    messages_list.each do |message|
      puts message
    end
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
