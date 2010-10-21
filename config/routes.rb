University::Application.routes.draw do
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
  
  resources :courses do
    resources :assignments, :controller => "Courses::Assignments" do
      resources :submissions, :controller => "Courses::Assignments::Submissions" do
        member do
          post :comment
          post :description
        end
      end
    end
  end
  
  get  "terms/:id/registration" => 'terms#registration', :as => 'registration'
  post "terms/:id/registration" => 'terms#register'
  
  namespace :admin do
    resources :users
    resources :courses do
      resources :assignments
    end

    resources :exams
    resources :terms
    resources :submission_statuses
  end
  
  resources :comments
  
  # TODO Remove these routes and replace with Exam#hash_url
  #get "exams/#{ENTRANCE_EXAM_HASH}" => 'exams#entrance',
  #     :as => 'entrance_exam'
  #post "exams/#{ENTRANCE_EXAM_HASH}" => 'exams#submit_exam',
  #     :as => 'submit_entrance_exam'
  
end
