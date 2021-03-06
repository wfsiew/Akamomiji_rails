AkamomijiRails::Application.routes.draw do
  root to: 'admin/admin#index'
  
  match 'login' => 'application#new', as: :login
  match 'auth' => 'application#create', as: :auth
  match 'logout' => 'application#destroy', as: :logout
  
  namespace :admin do
    match 'index' => 'admin#index', as: :index, via: :get
    
    scope 'job', as: 'job' do
      match '' => 'job_position#index', via: :get
      match 'list' => 'job_position#list', as: :list, via: [:get, :post]
      match 'new' => 'job_position#new', as: :new, via: :get
      match 'create' => 'job_position#create', as: :create, via: :post
      match 'edit(/:id)' => 'job_position#edit', as: :edit, via: :get
      match 'update(/:id)' => 'job_position#update', as: :update, via: :post
      match 'delete' => 'job_position#destroy', as: :delete, via: :post
      match 'find/name' => 'job_position#find_name', as: :find_name, via: :get
    end
    
    scope 'user', as: 'user' do
      match '' => 'user#index', via: :get
      match 'list' => 'user#list', as: :list, via: [:get, :post]
      match 'edit(/:id)' => 'user#edit', as: :edit, via: :get
      match 'update(/:id)' => 'user#update', as: :update, via: :post
    end
    
    scope 'staff', as: 'staff' do
      match '' => 'staff#index', via: :get
      match 'list' => 'staff#list', as: :list, via: [:get, :post]
      match 'new' => 'staff#new', as: :new, via: :get
      match 'create' => 'staff#create', as: :create, via: :post
      match 'edit(/:id)' => 'staff#edit', as: :edit, via: :get
      match 'update(/:id)' => 'staff#update', as: :update, via: :post
      match 'delete' => 'staff#destroy', as: :delete, via: :post
      match 'find/name' => 'staff#find_name', as: :find_name, via: :get
    end
    
    scope 'resv', as: 'resv' do
      match '' => 'reservation#index', via: :get
      match 'list' => 'reservation#list', as: :list, via: [:get, :post]
      match 'new' => 'reservation#new', as: :new, via: :get
      match 'create' => 'reservation#create', as: :create, via: :post
      match 'edit(/:id)' => 'reservation#edit', as: :edit, via: :get
      match 'update(/:id)' => 'reservation#update', as: :update, via: :post
      match 'delete' => 'reservation#destroy', as: :delete, via: :post
      match 'update/location(/:id)' => 'reservation#update_location', as: :update_location, via: :post
      match 'update/status(/:id)' => 'reservation#update_status', as: :update_status, via: :post
      match 'find/name' => 'reservation#find_name', as: :find_name, via: :get
    end
    
    scope 'sch', as: 'sch' do
      match 'find/active/name' => 'schedule#find_active_name', as: :find_active_name, via: :get
      match 'week_days' => 'schedule#week_days', as: :week_days, via: [:get, :post]
      
      scope 'kitchen', as: 'kitchen' do
        match '' => 'kitchen_sch#index', via: :get
        match 'list' => 'kitchen_sch#list', as: :list, via: [:get, :post]
        match 'new' => 'kitchen_sch#new', as: :new, via: :get
        match 'create' => 'kitchen_sch#create', as: :create, via: :post
        match 'edit(/:id)' => 'kitchen_sch#edit', as: :edit, via: :get
        match 'update(/:id)' => 'kitchen_sch#update', as: :update, via: :post
        match 'delete' => 'kitchen_sch#destroy', as: :delete, via: :post
        match 'update/location(/:id)' => 'kitchen_sch#update_location', as: :update_location, via: :post
        match 'find/name' => 'kitchen_sch#find_name', as: :find_name, via: :get
      end
      
      scope 'service', as: 'service' do
        match '' => 'service_sch#index', via: :get
        match 'list' => 'service_sch#list', as: :list, via: [:get, :post]
        match 'new' => 'service_sch#new', as: :new, via: :get
        match 'create' => 'service_sch#create', as: :create, via: :post
        match 'edit(/:id)' => 'service_sch#edit', as: :edit, via: :get
        match 'update(/:id)' => 'service_sch#update', as: :update, via: :post
        match 'delete' => 'service_sch#destroy', as: :delete, via: :post
        match 'update/location(/:id)' => 'service_sch#update_location', as: :update_location, via: :post
        match 'find/name' => 'service_sch#find_name', as: :find_name, via: :get
      end
    end
  end
  
  namespace :supervisor do
    match 'index' => 'supervisor#index', as: :index, via: :get
  end
  
  namespace :user do
    match 'index' => 'user#index', as: :index, via: :get
  end
  
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
