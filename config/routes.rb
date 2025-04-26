Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth", controllers: {
    registrations: "registrations"
  }

  resources :product_categories, only: [ :index, :show, :create, :update, :destroy ]
  resources :products do
    collection do
      get :shopping_list
    end
    member do
      patch :update_ideal_quantity
    end
  end
  resources :stock_movements, only: [ :index, :create ]
end
