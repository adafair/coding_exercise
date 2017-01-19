Rails.application.routes.draw do
  resources :events, except: [:create]
  resources :organizations do
    resources :events
  end
end
