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
  resources :orders, only: [:show] do
    resources :payments, only: [:new, :create]
  end
  resources :quick_buy_items, only: [:edit, :update, :destory]
  get 'orders/:id/complete', to: 'orders#complete', as: :orders_complete
  post 'payments/quick_buy', to: 'payments#quick_buy', as: :quick_buy

  get '/pricedrop', to: 'pages#pricedrop', as: :pricedrop

  # Routes for Google authentication
  get '/auth/google_oauth2', as: :google
  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/')
  get '/gmail', to: 'gmail_searcher#get_messages'

end
