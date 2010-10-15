University::Application.routes.draw do
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
  
  root :to => "home#show"
  
  namespace :chat do
    resources :messages
  end

  devise_for :users, :controllers => { :sessions => "user_sessions" }

  resource :home, :controller => "home"
  
  resources :users do
    member do
      post :change_password
    end
  end
  
  resources :assignments do
    resources :reviews, :controller => "Assignments::Reviews" do
      member do
        post :comment
      end
    end
  end
  
  namespace :admin do
    resources :users
    resources :courses do
      resources :assignments
    end

    resources :exams
    resources :submission_statuses
  end
  
  resources :comments
  
  get "exams/#{ENTRANCE_EXAM_HASH}" => 'exams#entrance',
       :as => 'entrance_exam'
  post "exams/#{ENTRANCE_EXAM_HASH}" => 'exams#submit_exam',
       :as => 'submit_entrance_exam'
  

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
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
end
