Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'password_resets/new'
  get 'password_resets/edit'

  root to: "landing_page#index"

  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]

  get    '/students_batch_import', to: 'students#batch_import'
  post   '/students_batch_import', to: 'students#batch_import'
  post   '/getStudentName', to: 'students#getStudentName'
  post   '/removeSupervisor', to: 'students#removeSupervisor'
  resources :students

  get    '/supervisors_batch_import', to: 'supervisors#batch_import'
  post   '/supervisors_batch_import', to: 'supervisors#batch_import'
  post   '/getSupervisorName', to: 'supervisors#getSupervisorName'
  post   '/removeStudent', to: 'supervisors#removeStudent'
  resources :supervisors

  get    '/assign',  to: 'assign#assign'
  post   '/assign',  to: 'assign#assign'
  get    '/batch_assign', to: 'assign#batch_assign'
  post   '/batch_assign', to: 'assign#batch_assign'

  resources :todos
  post   '/get_items',  to: 'todos#get_items'

  get    '/admin/',                     to: 'admin#activities'
  get    '/admin/trails',               to: 'admin#activities'
  get    '/admin/users',                to: 'admin#users'
  
  get '.well-known/acme-challenge/:file', to: 'application#acmeauth'
  
end
