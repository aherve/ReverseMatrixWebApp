Rails.application.routes.draw do
  get '/api/users/auth/google_oauth2', to: redirect('/users/auth/google_oauth2')
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks'}
  #devise_for :users
  mount API => '/api'
  mount GrapeSwaggerRails::Engine => '/api/doc' unless Rails.env.production?
end
