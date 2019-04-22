Rails.application.routes.draw do

  ## change the devise controller path to customise it
  devise_for :users, controllers:
    {
      confirmations: 'users/confirmations',
      registrations: 'users/registrations',
      sessions: 'users/sessions',
      passwords: 'users/passwords',
      unlocks: 'users/unlocks'
    }

  # Feed is main page
  root 'feed#index'
  get 'feed/user_info', to: 'feed#get_user_info'

  # http request redirected to events_controller
  resources :events, only: [:index, :create, :destroy]

  # http request redirected to university_mails_controller
  resources :university_mails, only: [:index]

  # http request redirected to event_participants_controller
  resources :event_participants, only: [:create, :update, :destroy]

  # http requested redirected to profile_controller
  get 'profile/created_events', to: 'profile#get_created_events'
  get 'profile/joined_events', to: 'profile#get_joined_events'
  get 'profile/event_join_demands', to: 'profile#get_event_join_demands'
  get 'profile/user_info', to: 'profile#get_user_info'
  get 'profile/show_avatar',to: 'profile#show_avatar'

  resources :profile, only: [:index, :update, :show]

  # http requested redirected to index function in sports_controller
  resources :sports, only: [:index]

end
