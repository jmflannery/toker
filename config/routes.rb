Toke::Engine.routes.draw do
  post 'register', to: 'users#create'

  post 'login', to: 'sessions#create'
  put 'login', to: 'sessions#update'
  delete 'logout', to: 'sessions#destroy'

  resources :users, only: [:index, :show]
end
