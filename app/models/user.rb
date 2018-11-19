class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	has_many :orders
	has_many :order_items, through: :orders
	has_many :quick_buy_items

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def find_or_create_pending_order
    @order = orders.find_by(state: "pending")
    if @order.nil?
      @order = Order.create(user: self, state: "pending")
    end
    return @order
  end
end
