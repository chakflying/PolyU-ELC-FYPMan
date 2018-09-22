Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'students/index'
  get 'landing_page/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "landing_page#index"
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/admin',   to: 'users#admin'
  resources :users
  get    '/students',to: 'students#index'
  post   '/students', to: 'students#create'
  get    '/students/:id', to: 'students#update'
  get    '/students_batch_import', to: 'students#batch_import'
  post   '/students_batch_import', to: 'students#batch_import'
  resources :students
  get    '/supervisors',to: 'supervisors#index'
  post   '/supervisors', to: 'supervisors#create'
  get    '/supervisors/:id', to: 'supervisors#update'
  get    '/supervisors_batch_import', to: 'supervisors#batch_import'
  post   '/supervisors_batch_import', to: 'supervisors#batch_import'
  resources :supervisors
  get   '/assign',  to: 'students#assign'
  post   '/assign',  to: 'students#assign'
  post   '/getStudentName', to: 'students#getStudentName'
  post   '/getSupervisorName', to: 'supervisors#getSupervisorName'
  post   '/removeStudent', to: 'supervisors#removeStudent'
  post   '/removeSupervisor', to: 'students#removeSupervisor'
  get    '/todos',       to: 'todos#show'
  post   '/todos',       to: 'todos#create'
  get    '/todos/:id',   to: 'todos#edit'
  delete '/todos',       to: 'todos#destroy'
  resources :todos
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
