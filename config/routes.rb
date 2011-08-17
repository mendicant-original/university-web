University::Application.routes.draw do
  root :to => "dashboard#show"

  get "alumni(/:year(/T:term))"    => 'public#alumni', :constraints => { :year => /\d{4}/ }, :as => 'alumni'
  get "alumni/recent" => 'public#recent_alumni'

  get "changelog" => 'public#changelog'
  get "changelog/:slug" => 'public#announcement'

  get "map" => 'public#map'

  resource :dashboard, :controller => "dashboard"

  namespace :chat do
    resources :messages do
      collection do
        get 'search'
      end
    end
  end
  get 'chat/discussions/:channel' => 'chat/messages#discussions', :as => 'chat_discussions'
  get 'chat/discussion/url'       => 'chat/messages#discussion_topic_url'

  get "transcripts/:channel" => 'Chat::Messages#transcripts'

  devise_for :users, :controllers => { :sessions => "user_sessions" }

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

    resources :reviews, :controller => "Courses::Reviews" do
      member do
        post :close
      end
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
          post :associate_with_github
        end
      end
    end
  end

  resources :documents

  namespace :admin do
    resources :users
    resources :courses do
      resources :assignments
    end
    resources :documents
    resources :announcements
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
        get  :thanks
        post :comment
        match '/:file' => 'submissions#attachment', :as => "attachment"
      end
    end
    resources :statuses
  end

  get "/admissions" => 'Admissions::Submissions#new'

end
