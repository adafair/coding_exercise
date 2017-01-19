Rails.application.routes.draw do
  # Routes for working with single Events as well as the root level Events index
  # call
  resources :events, except: [:create]

  # Routes for managing Organizations as well as Events within a single
  # Organization
  resources :organizations do
    resources :events, only: [:index, :create]
  end
end
