ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

  map.resource :account, :controller => 'users'
  map.resource :user_session

  map.resources :clients, :has_many => [:projects]
  map.resources :projects, :has_many => [:tasks]
  map.resources :tasks, :has_many => [:time_blocks],
                :member => {
                  :clock_in => :post,
                }
  map.resources :time_blocks

  map.clock_out 'clock_out', :controller => 'tasks', :action => 'clock_out', :method => :post

  # Dashboard actions
  map.with_options(:controller => 'dashboard') do |dash|
    dash.dashboard 'dashboard'

    # Don't bother naming the rest of them...
    dash.connect '/dashboard/:action'
  end

  # Report actions -- yes, name them all.
  map.with_options(:controller => 'reports') do |reports|
    reports.reports 'reports'  # not as bad as:  http://en.wikipedia.org/wiki/Buffalo_buffalo

    reports.hours_by_day '/reports/hours_by_day', :action => 'hours_by_day'
    reports.unused_tasks '/reports/unused_tasks', :action => 'unused_tasks'
  end


  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'dashboard'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
