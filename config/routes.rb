Wordtree::Application.routes.draw do
  resources :sentences

  resources :documents
  resources :terms

  root :to => 'terms#index'
end
