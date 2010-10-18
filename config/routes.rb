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
      resources :reviews, :controller => "Courses::Assignments::Reviews" do
        member do
          post :comment
        end
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
  
end
