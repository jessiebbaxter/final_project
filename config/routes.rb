Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
  	root :to => 'pages#dashboard', as: :authenticated
	end

	root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products, only: [:show, :index] do
    resources :quick_buy_items, only: [:create]
  end

  resources :order_items, only: [:create, :edit, :update, :destroy]
  resources :orders, only: [:show]
  resources :quick_buy_items, only: [:edit, :update, :destory]

end
