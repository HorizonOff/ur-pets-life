Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root 'pages#landing'
  get '/login', to: 'application#login'
  post 'send_message', to: 'pages#send_message', as: 'send_message_post'
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
        collection { put :set_push_token }
      end
      put 'users', to: 'users#update'

      get 'pets/:id/health_history', to: 'health_history#index'
      get 'pets/:id/weight_history', to: 'weight_history#index'
      get 'found_pets', to: 'pets#found_pets'
      resources :pets, except: %i[new edit] do
        collection { post :found }
        collection { get :can_be_lost }
        collection { get :can_be_adopted }
        member { put :lost }
        member { put :change_status }
      end
      resources :posts, only: %i[index create] do
        resources :comments, only: %i[index create]
      end
      resources :breeds, only: :index
      resources :vaccine_types, only: :index
      resources :pet_types, only: :index
      resources :clinics, only: %i[index show] do
        member { get :vets }
      end
      resources :additional_services, only: %i[index show]
      resources :grooming_centres, only: %i[index show] do
        member { get :schedule }
        member { get :services }
      end
      resources :day_care_centres, only: %i[index show] do
        member { get :schedule }
        member { get :services }
      end
      resources :boardings, only: %i[index show] do
        member { get :schedule }
        member { get :services }
      end
      resources :trainers, only: %i[index show]
      resources :emergencies, only: :index
      resources :adoptions, only: %i[index show]
      resources :lost_and_founds, only: %i[index show]
      resources :vets, only: :show do
        member { get :schedule }
      end
      resources :appointments, only: %i[index create show] do
        member { put :cancel }
      end
      resources :favorites, only: %i[index create destroy]

      resources :service_option_details, only: [] do
        member { get :time_ranges }
      end

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

      resources :notifications, only: :index do
        collection { get :unread }
      end
    end
  end

  resource :terms_and_conditions, only: :show

  devise_for :admins, path: 'admin_panel/admins', except: :registrations,
                      controllers: { invitations: 'admin_panel/admins/invitations' }

  namespace :admin_panel do
    root 'dashboard#index'

    resources :admins, only: %w[index destroy] do
      member { put :change_status }
      member { put :restore }
    end
    resource :terms_and_conditions, only: %i[edit update]
    resources :users, except: %i[new ceate]
    resources :pets, except: %i[new ceate] do
      member { get :weight_history }
      member { get :vaccinations }
      member { get :diagnoses }
    end
    resources :clinics do
      member { get :location }
      member { get :add_vet }
    end
    resources :day_care_centres do
      member { get :new_service_type }
    end
    resources :additional_services, except: :show
    resources :boardings do
      member { get :new_service_type }
    end
    resources :grooming_centres do
      member { get :new_service_type }
      member { get :calendar }
      member { get :timeline }
      member { get :appointments }
      member { post :lock_time }
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
    resources :blocked_times, only: %i[update destroy]
    resources :service_types, except: %i[new index show]
    resources :appointments, only: %i[index show] do
      resources :diagnoses, shallow: true, except: %i[index destroy]
      resource :next_appointment, shallow: true, only: %i[new create]
      member { put :accept }
      member { put :reject }
      member { put :cancel }
      member { put :update_duration }
    end
    resource :profile, only: %i[edit update]
    resource :password, only: %i[edit update]
    resources :contact_requests, only: %i[index show] do
      member { get :new_reply }
      member { post :send_reply }
    end
    resources :posts, only: %i[index show destroy], shallow: true do
      resources :comments, only: %i[index destroy]
    end
    resources :notifications
  end
end
