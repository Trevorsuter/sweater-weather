Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'forecast', to: 'forecast#index', as: 'forecast'
      get 'backgrounds', to: 'backgrounds#index', as: 'backgrounds'
      post 'users', to: 'users#create', as: 'users'
      post 'sessions', to: 'sessions#create', as: 'sessions'
    end
  end
end
