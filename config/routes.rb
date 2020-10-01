Rails.application.routes.draw do
  resources :pagas
  resources :deklarims
  resources :admins
  resources :pushims

  post "/kerkesas", to: "pushimes#kerkesa_create"
  get "/kerkesa", to: "pushimes#kerkesa"
  get "/kerkesas", to: "pushimes#kerkesas"
  get "/show", to: "pushimes#show"
  delete "/kerkesas/delete_image_attachment", to: "pushimes#delete_image_attachment"

	root 'users#index'

  get 'sessions/new', to: "sessions#new", as: :login
  get 'sessions/new_user', to: "sessions#new_user", as: :login_user
  post 'sessions/new', to: "sessions#create"
  post 'sessions/new_user', to: "sessions#create"
  delete '/log_out', to: "sessions#log_out", as: :logout
  delete '/log_out_user', to: "sessions#log_out_user", as: :logout_user

  resources :works do
  	collection { post :import; post :import_online}
  end

  resources :users

  resources :specific_contracts, only: [:update]
  get "/logs", to: "admins#logs", as: :logs
  get "/pushimet", to: "admins#pushimet", as: :pushimet

  post '/kerkesas/:id/finish_kerkesa', to: "pushimes#finish_kerkesa", as: :finish_kerkesa

  get 'deklarims/:id/show_xl', to: "deklarims#show_xl", as: :deklarim_xl
  get 'users/:id/gen_xl', to: 'users#gen_xl', as: :gen_xl
  get 'users/:id/gen_specific_xl', to: 'users#gen_specific_xl', as: :gen_specific_xl
  get 'users/:id/send_mail', to: 'users#send_email', as: :send_mail
  get 'users/:id/send_specific_mail', to: 'users#send_specific_email', as: :send_specific_mail
  post 'works/:id/pushimize', to: 'works#pushimize', as: :pushimize
  post 'pushimet_zyrtare', to: "admins#pushimet_zyrtare", as: :pushimet_zyrtare

  post 'users/:id/deklaro_pagen', to: "pagas#create", as: :deklaro_pagen
  post 'users/:id/specific_contract', to: "users#specific_contract"
  get 'users/:id/specific_contract', to: "users#specific_contract_days", as: :spec_cont
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
