LetsHire::Application.routes.draw do
  resources :AssessmentsController

  # all V1 rest api (for mobile) should be below
  namespace :api do
    namespace :v1 do

      get 'test' => 'misc#test_connection'

      devise_scope :user do
        resources :sessions, :only => [:create, :destroy]
        post 'login' => 'sessions#create'
        delete 'logout' => 'sessions#destroy'
      end

      resources :interviews, :only => [:index, :show, :update]

      post 'photo/upload' => 'photos#upload_file'
      get 'photo/enum' => 'photos#list_files'
      get 'photo/download' => 'photos#get_file'

      match 'mappings' => 'misc#mappings'
    end
  end
  # all V1 rest api (for mobile) should be above


  # Hacker for initialization
  get '/init', to: 'application#init'
  post '/init', to: 'application#admin_setup'

  root to: 'openings#index'
  match '/contact', to: 'static_pages#contact'

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

  get '/users/:id/disable', to: 'users#deactivate', as: :disable_user
  get '/users/:id/enable', to: 'users#reactivate', as: :enable_user
  devise_for :users  , :controllers => { :registrations => "registrations" }
  match '/profile', to: 'profile#edit'
  match '/profile/update', to: 'profile#update'
  get '/users/index_for_selection', to: 'users#index_for_selection'
  resources :users
  post '/opening_candidates', to: 'candidates#create_op_can'
  get '/candidates/:name/:id/:openingid/reject', to: 'candidates#setReject' ,:constraints => {:name => /.*/}
  get '/candidates/:name/:id/:openingid/:summary/offer', to: 'candidates#setOffer' ,:constraints => {:name => /.*/,:summary => /.*/ }
  get '/candidates/:name/:id/:openingid/remove', to: 'candidates#setRemove' ,:constraints => {:name => /.*/}
  get '/candidates/lock/:id', to: 'candidates#setLock'
  get '/interviewers/:openingcandidateid/:pageid/:list', to: 'candidates#create_delegated_interviewers'
  get '/departments/:id/user_select' => 'departments#user_select'
  #resources :departments

  get '/openings/opening_detail/:id' , to: 'openings#opening_detail'
  get '/openings/opening_detail_single/:interviewkey/:openingid/:candidateid' , to: 'openings#opening_detail_single'
  get '/openings/opening_detail_rejected/:id' , to: 'openings#opening_detail_rejected'
  get '/openings/opening_detail_offers/:id' , to: 'openings#opening_detail_offers'
  
  
  get '/getNotifications/:uid' , to: 'interviews#get_candidates'
  get '/setNotifications/:interviewersid' , to: 'interviews#set_interviewers' 
  get '/setCandidateSummary/:id/:summary', to: 'candidates#setSummary' ,:constraints => {:summary => /.*/ }
 
   resources :openings do
    collection do
      get 'opening_options'
    end
    member do
      post 'assign_candidates'
      get 'openingfile'
    end
  end
  resources :candidates do
    collection do
      get 'index_for_selection'
    end
    member do
      get 'legacy_show'
      post 'move_to_blacklist'
      post 'reactivate'
      get 'resume'
      get 'new_opening'
      put 'create_opening'
    end
  end

  resources :comments
 
  resources :interviews   do
    collection do
      get 'schedule_reload'
      get 'schedule_add'
      get 'edit_multiple'
      post 'update_multiple'
    end
  end

  resources :opening_candidates do
    resources :assessments
    resources :interviews
  end

  get '/addresses/subregion_options' => 'openings#subregion_options'

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
