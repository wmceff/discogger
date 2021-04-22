Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  root 'welcome#index'

  resources :queries do
    get 'run'
  end
  resources :records

  get 'oauth/callback' => 'welcome#index'
end
