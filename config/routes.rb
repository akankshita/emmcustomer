EmmPhase2::Application.routes.draw do
 
  resources :admins
  resources :customers
  resources :loginlogs
  resources :electricities
  resource :dashboards
  resource :settings
  resource :countries
  resource :states
  resource :cities
  resource :positions
  match "/state_change" => "admins#state_change"
  match "/city_change" => "admins#city_change"
  match "/" => "admins#sign_in"
  match "/customer/action" => "customers#action"
  match "sign_in" => "admins#sign_in"
  match "sign_in_act" => "admins#sign_in_act"
  match "/admin" => "admins#index"
  match "/signout" => "admins#sign_out"
  match "/signin" => "admins#sign_in"
  match "/loginlog/action" => "loginlogs#action"
  match "/admin/action" => "admins#action"
  match "/dashboard" => "dashboards#index"
  match "/setting" => "settings#index"
  match "/customer" => "customers#index"
  match "/loginlog" => "loginlogs#index"
  match "/electricity" => "electricities#index"
  match "/meterreading" => "electricities#import_csv"
  match "/test" => "electricities#test"
  match "/insert_to_customer_panel" => "electricities#insert_to_customer_panel"
  match "/cron_test" => "electricities#cron_test"
  
  
  match "/country" => "countries#index"
  match "/country/action" => "countries#action"
  match "/state" => "states#index"
  match "/state/action" => "states#action"
  match "/city" => "cities#index"
  match "/city/action" => "cities#action"
  match "/position" => "positions#index"
  match "/position/action" => "positions#action"
  
 
  
  # The priority is based upon order of creation:
  # first created -> highest priority.
  
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'admins#sign_in'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   match ':controller(/:action(/:id))(.:format)'
end
