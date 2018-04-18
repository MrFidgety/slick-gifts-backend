# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users, skip: :all

      resources :users, only: %i[create] do
        collection do
          # Set confirmation url used by devise
          resource :confirmation, only: %i[show],
                                  as: :user_confirmation
        end
      end
    end
  end
end
