Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :useres

  root "home#index"

  get 'get_geom_by_br/:br', to: "home#get_geom_by_br", as: 'get_geom'
  get 'get_geom_by_id/:item_id', to: "home#get_geom_by_id", as: 'get_geom_by_item'
  

  resources :rodovias do
	  resources :via_caracteristics
	end
  
end
