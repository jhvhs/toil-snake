Rails.application.routes.draw do
  resources :snakes do
    resources :scales
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
