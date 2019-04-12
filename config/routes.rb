# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'password_resets/new'
  get 'password_resets/edit'

  root to: 'landing_page#index'

  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/users',                to: 'admin#users'
  resources :users,               only: %i[new create show edit update destroy]
  get    '/password_resets',  to: 'password_resets#new'
  resources :password_resets,     only: %i[new create edit update]

  get    '/students_batch_import', to: 'students#batch_import'
  post   '/students_batch_import', to: 'students#batch_import'
  post   '/removeSupervisor', to: 'students#removeSupervisor'
  resources :students

  get    '/supervisors_batch_import', to: 'supervisors#batch_import'
  post   '/supervisors_batch_import', to: 'supervisors#batch_import'
  post   '/removeStudent', to: 'supervisors#removeStudent'
  resources :supervisors

  get    '/assign',   to: 'assign#assign'
  post   '/assign',   to: 'assign#assign'
  post   '/unassign', to: 'assign#unassign'
  get    '/batch_assign', to: 'assign#batch_assign'
  post   '/batch_assign', to: 'assign#batch_assign'

  resources :todos

  scope '/admin' do
    get    '/',                     to: 'admin#activities'
    get    '/trails',               to: 'admin#activities'
    get    '/console',               to: 'admin#webconsole'
    resources :departments
  end

  get '/not_found', to: 'errors#show', code: 404

  %w[404 422 500 503].each do |code|
    get code, to: 'errors#show', code: code
  end
end
