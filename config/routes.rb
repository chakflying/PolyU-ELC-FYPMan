Rails.application.routes.draw do
  get 'students/index'
  get 'landing_page/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "landing_page#index"
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  get    '/students',to: 'students#index'
  post   '/students', to: 'students#create'
  resources :students
  get    '/supervisors',to: 'supervisors#index'
  post   '/supervisors', to: 'supervisors#create'
  resources :supervisors
  get   '/assign',  to: 'students#assign'
  post   '/assign',  to: 'students#assign'
  post   '/getStudentName', to: 'students#getStudentName'
  post   '/getSupervisorName', to: 'supervisors#getSupervisorName'
end
