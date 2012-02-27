Wordtree::Application.routes.draw do
  resources :words
  resources :trees
  resources :sentences
  resources :documents
  resources :terms
  root to: 'trees#index'
end
