Toke::Engine.routes.draw do
  resources :users, only: [:create, :index, :show]
  resources :sessions, only: [:create, :destroy]
end
