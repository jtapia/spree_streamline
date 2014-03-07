Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :stock_removals
  end
end