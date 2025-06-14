Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth", controllers: {
    registrations: "registrations"
  }

  devise_scope :user do
    get "me", to: "users#me"
  end

  resources :product_categories, only: [ :index, :show, :create, :update, :destroy ]
  resources :products do
    get :shopping_list, on: :collection

    patch :update_ideal_quantity, on: :member
    patch :withdraw_from_stock, on: :member
    patch :reverse_withdrawal, on: :member
    patch :restock, on: :member
  end
  resources :stock_movements, only: [ :index, :show ] do
    collection do
      get :inventory_report
    end
  end
end
