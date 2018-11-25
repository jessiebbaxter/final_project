class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: :home

  def home
  end

  def dashboard
  end

  
  def alert
    
    @products = Product.all.sample(10).flatten
  end

end
