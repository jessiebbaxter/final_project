class PaymentsController < ApplicationController
   before_action :set_order
   helper_method :finalise_total

  def new
  end

  def create
    if current_user.customer_id
      one_click_purchases
    else
      customer = Stripe::Customer.create(
        source: params[:stripeToken],
        email:  params[:stripeEmail]
      )

      charge = Stripe::Charge.create(
        customer:     customer.id,
        amount:       @order.amount_cents,
        description:  "Payment for order #{@order.id}",
        currency:     @order.amount.currency
      )

      current_user.update(customer_id: customer.id)
      @order.update(payment: charge.to_json, state: 'paid')
      redirect_to orders_complete_path(@order)
    end
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_order_payment_path(@order)
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

