# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :sessions, only: %i[create destroy]

      resources :users, only: %i[create] do
        collection do
          # Set confirmation url used by devise
          resource :confirmation, only: %i[show],
                                  as: :user_confirmation,
                                  controller: 'users/confirmations'
        end
      end
    end
  end
end
