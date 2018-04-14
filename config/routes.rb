# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_scope :user do
        resources :users, only: %i[create]
      end

      namespace :users do
        resource :me, only: %i[show], controller: :my_users
      end
    end
  end
end
