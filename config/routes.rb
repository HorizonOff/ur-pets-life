Rails.application.routes.draw do
  root 'admin_panel/dashboard#index'
  get '/login', to: 'application#login'
  devise_for :users, only: %i[confirmations passwords omniauth_callbacks],
                     controllers: { confirmations: 'confirmations',
                                    passwords: 'passwords',
                                    omniauth_callbacks: 'omniauth_callbacks' }
  namespace :api do
    namespace :v1 do
      resources :apidocs, only: :index
      resources :users, only: :create do
        collection { get :profile }
      end
      put 'users', to: 'users#update'

      get 'pets/:id/health_history', to: 'health_history#index'
      get 'pets/:id/weight_history', to: 'weight_history#index'
      resources :pets, except: %i[new edit]

      resources :breeds, only: :index
      resources :vaccine_types, only: :index
      resources :pet_types, only: :index
      resources :clinics, only: %i[index show]
      resources :grooming_centres, only: %i[index show]
      resources :day_care_centres, only: %i[index show]
      resources :trainers, only: %i[index show]
      resources :emergencies, only: :index
      resources :adoptions, only: %i[index show]
      resources :vets, only: :show
      resources :appointments, only: %i[index create show]

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

  devise_for :admins, path: 'admin_panel/admins', except: :registrations
  namespace :admin_panel do
    resources :admins, except: :create
    resource :profile, only: %i[edit update]
    resource :password, only: %i[edit update]
  end
end
