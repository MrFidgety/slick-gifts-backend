# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users, skip: :all

      resources :users, only: %i[create]

      namespace :user do
        # confirmation url required for devise confirmable
        resource :confirmation, only: %i[show]
      end

      namespace :users do
        resource :me, only: %i[show], controller: :my_users
      end
    end
  end
end
