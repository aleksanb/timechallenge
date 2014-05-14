TimeChallenge::Application.routes.draw do
  resources :challenges do
    resources :participations, only: [:create, :destroy]
  end

  root 'challenges#index'

  match 'auth/:provider/callback', to: 'sessions#create',
        via: [:get, :post]
  match 'auth/failure', to: redirect('/'),
        via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout',
        via: [:get, :post]

end
