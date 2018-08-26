# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :blockades, only: %i[create destroy]

      resources :friend_requests, only: %i[create destroy],
                                  path: 'friend-requests' do
        post :accept, on: :member
      end

      resources :friendships, only: %i[destroy]

      resources :sessions, only: %i[create destroy]

      resources :users, only: %i[create index] do
        collection do
          # Set confirmation url used by devise
          resource :confirmation, only: %i[show],
                                  as: :user_confirmation,
                                  controller: 'users/confirmations'
        end

        resources :blockades,
                  only: %i[index],
                  controller: 'users/blockades'

        resources :friends,
                  only: %i[index],
                  controller: 'users/friends'

        resources :friend_requests,
                  only: [],
                  controller: 'users/friend_requests',
                  path: 'friend-requests' do
          collection do
            get :sent
            get :received
          end
        end
      end
    end
  end
end
