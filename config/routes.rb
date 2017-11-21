Rails.application.routes.draw do
  root to: 'application#index'

  devise_for :users, only: %i[confirmations passwords omniauth_callbacks],
                     controllers: { confirmations: 'confirmations',
                                    passwords: 'passwords',
                                    omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :apidocs, only: [:index]
      resources :pages, only: :index
      resources :users, only: :create
      put 'users', to: 'users#update'
      resources :sessions, only: :create do
        collection { post :facebook }
        collection { post :google }
      end
      delete 'sessions', to: 'sessions#destroy'
      resources :passwords, only: [] do
        collection { post :forgot }
      end
      put 'passwords', to: 'passwords#update'

      get '/users/auth/google_oauth2/callback', to: 'application#index'
    end
  end
end
