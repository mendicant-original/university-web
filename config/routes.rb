University::Application.routes.draw do
  root :to => "dashboard#show"
  
  get "alumni"    => 'public#alumni'
  get "changelog" => 'public#changelog'
  get "changelog/:slug" => 'public#announcement'
  
  resource :dashboard, :controller => "dashboard"
  
  namespace :chat do
    resources :messages
  end
  get 'chat/discussions/:channel' => 'chat/messages#discussions', :as => 'chat_discussions'
  get 'chat/discussion/url'       => 'chat/messages#discussion_topic_url'
  
  get "transcripts/:channel" => 'Chat::Messages#transcripts'

  devise_for :users, :controllers => { :sessions => "user_sessions" }

  resource :home, :controller => "home"
  
  get "slugger" => "slugger#index", :as => "slugger"
  
  resources :users do
    member do
      post :change_password
    end
  end
  
  resources :courses do
    member do
      post :notes
      get  :directory
    end
    
    resources :documents, :controller => "Courses::Documents"
    
    resources :assignments, :controller => "Courses::Assignments" do
      member do
        post :notes
      end
      
      resources :submissions, :controller => "Courses::Assignments::Submissions" do
        member do
          post :comment
          post :description
        end
      end
    end
  end
  
  resources :documents
  
  get  "terms/:id/registration" => 'terms#registration', :as => 'registration'
  post "terms/:id/registration" => 'terms#register'
  
  namespace :admin do
    resources :users
    resources :courses do
      resources :assignments
    end
    resources :documents
    resources :announcements
    resources :exams
    resources :terms
    resources :submission_statuses
    resources :group_mails, :only => [:new, :create] do
      collection do
        get :update_group_select
        get :user_emails
      end
    end
    
    namespace :chat do
      resources :channels
    end
  end
  
  resources :comments
  
  namespace :admissions do
    resources :submissions do
      member do
        match '/:file' => 'Submissions#attachment', :as => "attachment"
      end
    end
  end

  get "/admissions" => 'Admissions::Submissions#new'
  
end
