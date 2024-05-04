Rails.application.routes.draw do
  devise_for :admins
  get 'home/index'

  get 'authorize' => 'o_auth_2#authorize'
  match '/oauth2_callback', to: Google::Auth::WebUserAuthorizer::CallbackApp, via: :all

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'
end
