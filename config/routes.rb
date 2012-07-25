Zhule::Application.routes.draw do

  root :to => 'index#index', :as => :root
  match 'sign_in' => 'index#index', :as => :sign_in
  match 'sign_up' => 'index#sign_up', :as => :sign_up, :via => [:get, :post]
  match 'sign_out' => 'index#sign_out', :as => :sign_out
  match 'home' => 'home#index', :as => :home

  resources :users do
    member do
      post :follow
    end
  end

  resources :dialogs do
    member do
      post :send_message
    end
  end

  resources :assistances, :except => [:index] do
    member do
      get :joined
      post :join
    end
  end
  

  scope 'settings' do
    match '/' => 'settings#index', :as => :settings, :via => [:get, :post]
    match 'password' => 'settings#password', :as => :setting_password, :via => [:get, :post]
    match 'avatar' => 'settings#avatar', :as => :setting_avatar, :via => [:get, :post]
  end
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end