OfflineWebApp::Application.routes.draw do

  resources :items, :only => [] do
    collection do
      get 'sync'
      post 'sync'
    end
  end

  root :to => 'home#index'

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'


  offline = Rack::Offline.configure do
    public_path = Rails.public_path

    files = Dir[
      "#{public_path}/images/**/*.*",
      "#{public_path}/stylesheets/themes/activo/fonts/*"
    ]
    files.each do |file|
      cache file.gsub(public_path, "")
    end

    cache "/assets/common.css"
    cache "/assets/common.js"
    cache "/assets/app.js"

    cache "/stylesheets/themes/activo/images/bgd.jpg"
    cache "/stylesheets/themes/activo/images/boxbar-background.png"
    cache "/stylesheets/themes/activo/images/breadcrumb.png"
    cache "/stylesheets/themes/activo/images/button-background-active.png"
    cache "/stylesheets/themes/activo/images/button-background.png"

    cache "/stylesheets/themes/activo/images/icons/add.png"
    cache "/stylesheets/themes/activo/images/icons/tick.png"
    cache "/stylesheets/themes/activo/images/icons/cross.png"
    cache "/stylesheets/themes/activo/images/icons/24/show.png"
    cache "/stylesheets/themes/activo/images/icons/24/edit.png"
    cache "/stylesheets/themes/activo/images/icons/24/cross.png"
    cache "/stylesheets/themes/activo/images/icons/24/show-hover.png"
    cache "/stylesheets/themes/activo/images/icons/24/edit-hover.png"
    cache "/stylesheets/themes/activo/images/icons/24/cross-hover.png"

    network "/"
  end

  match "/application.manifest" => offline
end
