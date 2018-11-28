class SessionsController < ApplicationController

  def googleAuth
    raise
    # Get access tokens from the google server
    access_token = request.env["omniauth.auth"]

    # Access_token is used to authenticate request made from the rails application to the google server
    current_user.google_token = access_token.credentials.token
    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = access_token.credentials.refresh_token
    current_user.google_refresh_token = refresh_token if refresh_token.present?
    current_user.save
    redirect_to root_path
  end
end
