Rails.application.routes.draw do
  root 'mihans#index'
  resources :mihans do
    post 'generate_report', on: :collection
  end  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :mihan_mowatans do
    post 'generate_report', on: :collection
  end  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
