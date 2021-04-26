Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'forecast', to: 'forecast#index', as: 'forecast'
      get 'backgrounds', to: 'backgrounds#index', as: 'backgrounds'
    end
  end
end
