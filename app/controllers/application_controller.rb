class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :store_location
  helper_method :finalise_total

  protected

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&

        request.path != "/admins/sign_in" &&

        request.path != "/admin" &&

        request.path != "/users/sign_up" &&

        request.path != "/users/password/new" &&

        request.path != "/users/password/edit" &&

        request.path != "/users/confirmation" &&

        request.path != "/users/sign_out" &&

        !request.xhr?) # don't store ajax calls

      session[:previous_url] = request.fullpath
    end
  end

  def default_url_options
    { host: ENV["www.bellabird.net"] || "localhost:3000" }
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def after_sign_out_path_for(resource)
    session[:previous_url] || root_path
  end

  def finalise_total
    set_shipping_price
    @order.amount = 0
    @order.order_items.each do |item|
      if item.inventory.coupon
        @order.amount += ((item.inventory.price * (1 - item.inventory.coupon.discount)) * item.qty)
      else
        @order.amount += (item.inventory.price * item.qty)
      end
    end
    @order.amount += @ship.cost
    @order.save
  end

  def set_shipping_price
    @shipping_array = []
    @shipping_list = Shipping.where(seller_id: @order.inventories.first.seller_id)
    @shipping_list.order(cost_cents: :asc).each do |ship|
      if ship.minimum_spend.to_i < @order.inventories.first.price.to_i
        @shipping_array << ship
      end
    end
    @ship = @shipping_array.first
  end
end
