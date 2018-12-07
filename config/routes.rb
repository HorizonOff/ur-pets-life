Rails.application.routes.draw do

  resources :redeem_points
  resources :recurssion_intervals
  resources :item_reviews
  resources :order_items
  resources :orders
  resources :shopping_cart_items
  resources :wishlists
  resources :items
  resources :item_brands
  resources :item_categories
  mount Ckeditor::Engine => '/ckeditor'
  root 'pages#newlanding'
  get '/login', to: 'application#login'
  get '/privacy_policy_new', to:'pages#send_message', as:'view_pp'
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
      resources :redeem_points
      resources :recurssion_intervals
      resources :item_reviews
      resources :orders
      resources :items
      resources :shipping_addresses
      resources :wishlists
      resources :item_categories
      resources :item_brands
      resources :shopping_cart_items
      get 'test_email_notifications', to:'orders#test_email'
      get 'get_app_base_path_url', to:'order_items#app_base_end_point'
      post 'order_item_change_status', to:'order_items#changer_order_status'
      get 'recurring_item/:id/cancel', to:'order_items#order_item_cancel_recurring'
      get 'order_item/:id/cancelorder', to:'order_items#order_item_cancel_order'
      get 'order_item/:id/reorder', to:'order_items#order_item_reorder'
      get 'get_current_orders', to:'order_items#get_pending_order_items'
      get 'get_orders_history', to:'order_items#get_completed_order_items'
      get 'get_recurring_orders', to:'order_items#get_recurring_order_items'
      post 'search_items_by_keywords', to:'items#search_items_by_keywords'
      get 'get_shopping_cart_stats', to:'shopping_cart_items#get_cart_stats'
      get 'get_vat_percentage', to:'order_items#get_vat_percentage'
      get 'pets_life_documentations', to:'order_items#gen_api_end_points'
      post 'order/:id/reorder', to:'orders#re_oder_on_order_id'
      get 'item_category/:id/items', to:'items#get_items_by_item_category'
      get 'pet_type/:id/items', to:'items#get_items_by_pet_type'
      post 'search_items_filter', to:'items#search_items_using_filters'
      get 'item/:id/reviews', to:'item_reviews#review_by_item_id'
      get 'wishlist/:id/additem', to:'wishlists#add_item_to_wish_list'
      get 'brand/:id/items', to:'items#item_by_brand_id'
      get 'category/:id/brands', to: 'item_brands#item_cat_brands'
      put 'users', to: 'users#update'
      get 'category/:id/shopping_categories', to: 'item_categories#item_cat_for_pet_type'
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
        resources :comments, only: %i[index create]
      end
      resources :commented_appointments, only: :index
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

      get 'app_version', to: 'app_versions#show'
    end
  end

  resource :terms_and_conditions, only: :show
  get 'loyalty_program', to:'pages#loyalty_program'
  get 'app_loyalty_program', to:'pages#app_loyalty_program'
  get 'privacy_policy', to: 'pages#privacy_policy'
  get 'cancelation_policy', to: 'pages#cancelation_policy'
  get 'app_cancelation_policy', to: 'pages#app_cancelation_policy'
  get 'term_conditions', to:'pages#term_conditions'
  get 'app_term_conditions', to:'pages#app_term_conditions'
  get 'pets_life_privacy_policy', to: 'pages#new_privacy_policy'
  get 'app_pets_life_privacy_policy', to: 'pages#app_new_privacy_policy'
  devise_for :admins, path: 'admin_panel/admins', except: :registrations,
                      controllers: { invitations: 'admin_panel/admins/invitations' }

  namespace :admin_panel do
    root 'dashboard#index'

    resources :admins, only: %w[index destroy] do
      member { put :change_status }
      member { put :restore }
    end
    resources :orders
    resources :items
    resources :item_brands
    resources :item_categories
    resources :pettypes
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
    resources :specializations, except: :show
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
      resources :comments, only: %i[index create]
    end
    resource :profile, only: %i[edit update]
    resource :password, only: %i[edit update]
    resources :contact_requests, only: %i[index show] do
      member { get :new_reply }
      member { post :send_reply }
    end
    resources :posts, only: %i[index show destroy], shallow: true do
      resources :comments, only: %i[index create]
    end
    resources :comments, only: :destroy
    resources :notifications

    resource :app_version, only: %i[edit update]
  end
end
