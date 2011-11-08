PrototypeThewordtreeNet::Application.routes.draw do
  resources :term_mappings
  resources :terms
  resources :disciplines
  resources :genres
  resources :documents do
    get 'page/:page', :action => :index, :on => :collection
  end
  
  # namespace :admin do
  # match ':controller(/:action(/:id(.:format)))'
#root :to => 'high_voltage/pages#show', :id => 'home'
  root :to => 'documents#index'
end
