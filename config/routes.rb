Rails.application.routes.draw do
  
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  resources :users
  resources :mihans do
    post 'generate_report', on: :collection
  end  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :mihan_mowatans do
    post 'generate_report', on: :collection
  end  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :guides do
    post 'generate_report', on: :collection
  end  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'application#index'

  mount ActionCable.server => '/cable'
  resources :tickets do
    post 'chat', to: 'tickets#chat'
  end
  
  # Defines the root path route ("/")
  # root "articles#index"
end
