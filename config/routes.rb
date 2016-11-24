Toke::Engine.routes.draw do
  resources :users, only: [:create, :index, :show]

  post 'login',  to: 'sessions#create'
  put 'login', to: 'sessions#update'
  delete 'logout', to: 'sessions#destroy'
end
