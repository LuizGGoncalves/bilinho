Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  get '/institutions', to: "institutions#index"
  get '/institutions/:id', to: 'institutions#show'
  post '/institutions', to: 'institutions#create'
  patch '/institutions/:id/update', to: 'institutions#update'
  delete '/institutions/:id/destroy', to: 'institutions#destroy'

  get '/institutions/link_user/:id', to: 'institutions#link_user_to_institutions'
  patch '/institutions/update_info', to: 'institutions#self_info_update'

  get '/students', to: "students#index"
  get '/students/:id', to: 'students#show'
  post '/students', to: 'students#create'
  patch '/students/:id', to: 'students#update'
  delete '/students/:id', to: 'students#destroy'

  post '/students/createUpdate', to: 'students#register_update_student_info'

  get '/registrations', to: "registrations#index"
  get '/registrations/:id', to: 'registrations#show'
  post '/registrations', to: 'registrations#create'
  patch '/registrations/:id/edit', to: 'registrations#update'
  delete '/registrations/:id/delete', to: 'registrations#destroy'

  post '/registrations/user_create/:instId', to: 'registrations#user_create_registration'

  get '/bills', to: "bills#index"
  get '/bills/:id', to: 'bills#show'
  post '/bills', to: 'bills#create'
  patch '/bills/:id/edit', to: 'bills#update'
  delete '/bills/:id/delete', to: 'bills#delete'

  get '/user/bills', to: 'bills#show_user_bill'
  get '/user/registrations', to: 'registrations#user_registrations'

  devise_scope :user do
    get '/user/info', to: "users#self_info"
  end
end
