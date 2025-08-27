Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    namespace :v1 do
      # Health check
      get 'health', to: 'application#health_check'
      
      # Authentication
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'
      get 'auth/me', to: 'auth#me'
      
      # Tours
      resources :tours, only: [:index, :show, :create, :update, :destroy]
      
      # Bookings
      resources :bookings, only: [:index, :show, :create, :update, :destroy]
      
      # OBS API Integration
      namespace :obs do
        get 'tours', to: 'obs#tours'
        get 'tours/:id', to: 'obs#tour_detail'
        get 'tours/search', to: 'obs#search_tours'
        get 'tours/featured', to: 'obs#featured_tours'
        get 'tours/categories', to: 'obs#categories'
        get 'tours/:id/availability', to: 'obs#tour_availability'
        post 'bookings', to: 'obs#create_booking'
        get 'bookings/:id', to: 'obs#booking_status'
      end
      
      # Data Synchronization
      namespace :sync do
        get 'status', to: 'sync#sync_status'
        post 'tours', to: 'sync#sync_tours'
        post 'tours/:id', to: 'sync#sync_tour'
        post 'all', to: 'sync#sync_all'
      end
      
      # Dashboard / Personal Cabinet
      namespace :dashboard do
        get '', to: 'dashboard#index'
        get 'stats', to: 'dashboard#stats'
        patch 'profile', to: 'dashboard#profile'
        get 'notifications', to: 'dashboard#notifications'
        patch 'notifications/:id/read', to: 'dashboard#mark_notification_read'
        get 'recommendations', to: 'dashboard#recommendations'
        get 'booking_history', to: 'dashboard#booking_history'
        get 'favorites', to: 'dashboard#favorites'
        post 'favorites/:tour_id', to: 'dashboard#add_to_favorites'
        delete 'favorites/:tour_id', to: 'dashboard#remove_from_favorites'
      end
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
