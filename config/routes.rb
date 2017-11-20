Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :apidocs, only: [:index]
      resources :pages, only: :index
      resources :users, only: :create
      resources :sessions, only: %i[create destroy] do
        collection { post :facebook }
        collection { post :google_plus }
      end
    end
  end

end
