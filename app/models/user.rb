class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	has_many :orders
	has_many :order_items, through: :orders
	has_many :quick_buy_items

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |user|
      user.name = auth.info.name
      user.email = auth.info.email
    end
  end

  def find_or_create_pending_order
    @order = orders.find_by(state: "pending")
    if @order.nil?
      @order = Order.create(user: self, state: "pending")
    end
    return @order
  end
end
