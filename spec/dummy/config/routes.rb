Rails.application.routes.draw do

  mount Toker::Engine => "/toke"

  get 'admin/things', to: 'things#admin_index'
  get 'things', to: 'things#index'
end
