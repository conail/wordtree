Wordtree::Application.routes.draw do
  resources :add_genres
  resources :disciplines
  resources :branches
  resources :words
  resources :trees
  resources :sentences
  resources :documents
  resources :terms
  resources :nodes
  root to: 'trees#show', id: 'of'
end
