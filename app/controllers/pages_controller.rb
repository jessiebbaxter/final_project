class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    # ...
  end

  def dashboard
    @quick_buy_list = QuickBuyItem.where(user_id: current_user.id)
  end

  def pricedrop
    @quick_buy_list = QuickBuyItem.where(user_id: current_user.id)
  end
end
