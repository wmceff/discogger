Rails.application.routes.draw do
  root 'queries#index'

  resources :queries do
    get 'run'
  end
  resources :records

  get 'oauth/callback' => 'welcome#index'
end
