Rails.application.routes.draw do

  get '/about' => 'static_pages#about'
  get '/edit_profile/:id' => 'static_pages#edit_profile', as: 'edit_profile'
  get '/my_projects/:id' => 'users#my_projects', as: 'my_projects'

  get '/projects/:id/push_stage' => 'projects#push_stage'

  get '/users/add_to_my_projects' => 'users#add_to_my_projects'

  root 'static_pages#home'

  resources :projects do
    member do
      put "like" => "projects#upvote"
      put "dislike" => "projects#downvote"
    end
  end
  resources :project_leaders
  resources :vacants
  resources :support_tickets
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:index, :show, :new, :create] do
    member do
      get :confirm_email
    end
  end

  get "/login" => "sessions#new", as: "login"
  delete "/logout" => "sessions#destroy", as: "logout"
  get "/register" => "users#new", as: "register"


  mount Commontator::Engine => '/commontator'
end
