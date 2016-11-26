Rails.application.routes.draw do

  mount Toke::Engine => "/toke"

  get 'admin/things', to: 'things#admin_index'
  get 'things', to: 'things#index'
end
