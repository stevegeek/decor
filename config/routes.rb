Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  mount Lookbook::Engine, at: "/lookbook"

  # CloudStack Pro Example Pages
  namespace :cloudstack do
    # Dashboard
    get 'dashboard', to: 'cloudstack#dashboard'
    
    # Instance Management
    resources :instances do
      member do
        post 'action/:action_type', to: 'instances#action', as: 'action'
      end
    end
    
    # User Profile & Settings
    resource :profile, only: [:show, :edit, :update], controller: 'profile'
    resource :settings, only: [:show, :update], controller: 'settings' do
      post 'generate_api_key', on: :member
    end
    
    # Billing & Usage
    namespace :billing do
      get '/', to: 'billing#index', as: 'index'
      get 'usage', to: 'billing#usage'
      get 'history', to: 'billing#history'
      get 'download/:id', to: 'billing#download_invoice', as: 'download_invoice'
    end
    
    # Support & Documentation
    namespace :support do
      get '/', to: 'support#index', as: 'index'
      get 'docs', to: 'support#docs'
      get 'tickets', to: 'support#tickets'
      get 'tickets/:id', to: 'support#show_ticket', as: 'ticket'
      get 'tickets/new', to: 'support#new_ticket', as: 'new_ticket'
      post 'tickets', to: 'support#create_ticket', as: 'create_ticket'
      post 'tickets/:ticket_id/messages', to: 'support#add_message', as: 'add_message'
    end
  end

  # Defines the root path route ("/")
  root to: redirect("/lookbook")
end
