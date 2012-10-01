Wordtree::Application.routes.draw do
  resources :trees
  resources :nodes
  root to: 'trees#index'
end
