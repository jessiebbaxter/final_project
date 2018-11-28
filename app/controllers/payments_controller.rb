class PaymentsController < ApplicationController
   before_action :set_order, except: [:quick_buy]
   helper_method :finalise_total

  def new
  end

  def create
    if current_user.customer_id
      one_click_purchases
    else
      save_customer_details

      charge = Stripe::Charge.create(
        customer:     @customer.id,
        amount:       @order.amount_cents,
        description:  "Payment for order #{@order.id}",
        currency:     @order.amount.currency
      )

      current_user.update(customer_id: @customer.id)
      @order.update(payment: charge.to_json, state: 'paid')
      redirect_to orders_complete_path(@order)
    end
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_order_payment_path(@order)
  end

  def quick_buy
    @order = Order.create!(user_id: current_user.id, state: "pending")
    if params[:qty].nil?
      @order_item = OrderItem.create!(inventory_id: params[:inventory_id], order_id: @order.id, qty: 1)
    else
      @order_item = OrderItem.create!(inventory_id: params[:inventory_id], order_id: @order.id, qty: params[:qty])
    end
    @order.order_items.each do |item|
      @order.amount += (item.inventory.price * item.qty)
    end
    @order.save
    create
  end

  private

  def save_customer_details
    @customer = Stripe::Customer.create(
      source: params[:stripeToken],
      email:  params[:stripeEmail]
    )

    current_user.update(
      first_name: params[:first_name],
      last_name: params[:last_name],
      street_address: params[:street_address],
      suburb: params[:suburb],
      state: params[:state],
      post_code: params[:postcode]
    )
  end

  def one_click_purchases
    customer = Stripe::Customer.retrieve(current_user.customer_id)
    charge = Stripe::Charge.create(
      customer:     customer.id,
      amount:       @order.amount_cents,
      description:  "Payment for order #{@order.id}",
      currency:     @order.amount.currency
    )
    @order.update(payment: charge.to_json, state: 'paid')
    redirect_to orders_complete_path(@order)
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to new_order_payment_path(@order)
  end

  def finalise_total
    @order.amount = 0
    @order.order_items.each do |item|
      @order.amount += (item.inventory.price * item.qty)
    end
    @order.save
  end

private

  def set_order
    @order = current_user.orders.where(state: 'pending').find(params[:order_id])
  end
end

