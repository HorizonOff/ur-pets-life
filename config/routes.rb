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
      resources :contact_requests, only: [:create]
      resources :users, only: :create do
        collection { get :profile }
      end
      put 'users', to: 'users#update'

      get 'pets/:id/health_history', to: 'health_history#index'
      get 'pets/:id/weight_history', to: 'weight_history#index'
      resources :pets, except: %i[new edit] do
        collection { post :found }
        collection { get :can_be_lost }
        collection { get :can_be_adopted }
        member { put :lost }
        member { put :change_status }
      end

      resources :breeds, only: :index
      resources :vaccine_types, only: :index
      resources :pet_types, only: :index
      resources :clinics, only: %i[index show]
      resources :grooming_centres, only: %i[index show] do
        member { get :schedule }
      end
      resources :day_care_centres, only: %i[index show] do
        member { get :schedule }
      end
      resources :trainers, only: %i[index show]
      resources :emergencies, only: :index
      resources :adoptions, only: %i[index show]
      resources :lost_and_founds, only: %i[index show]
      resources :vets, only: :show do
        member { get :schedule }
      end
      resources :appointments, only: %i[index create show]
      resources :favorites, only: %i[index create destroy]

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
    resources :users, except: %i[new ceate]
    resources :pets, except: %i[index new ceate] do
      member { get :weight_history }
    end
    resources :clinics do
      member { get :location }
      member { get :add_vet }
    end
    resources :day_care_centres do
      member { get :new_service_type }
    end
    resources :grooming_centres do
      member { get :new_service_type }
    end
    resources :vets do
      member { get :schedule }
      resources :calendars, shallow: true, only: %i[index create destroy update] do
        collection { get :timeline }
        collection { get :appointments }
      end
    end
    resources :trainers do
      member { get :new_service_type }
    end
    resources :service_types, except: %i[new index show]
    resources :appointments, only: %i[index show] do
      resources :diagnoses, shallow: true, except: %i[index destroy]
      resource :next_appointment, shallow: true, only: %i[new create]
      member { put :accept }
      member { put :reject }
    end
    resource :profile, only: %i[edit update]
    resource :password, only: %i[edit update]
  end
end
