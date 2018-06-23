# frozen_string_literal: true

module Api
  module V1
    module Users
      class FriendRequestsController < ApiController
        authorize action: :sent, auths: { user: :list_sent_friend_requests }
        authorize action: :received, auths: { user: :list_received_friend_requests }

        enable_pagination_for :sent, :received

        enable_inclusions_for sent: %i[friend], received: %i[user]

        def sent
          respond_with friend_requests,
                       include: included_resources,
                       links: { self: sent_api_v1_user_friend_requests_url(user) }
        end

        def received
          respond_with received_friend_requests,
                       include: included_resources,
                       links: { self: received_api_v1_user_friend_requests_url(user) }
        end

        private

        def friend_requests
          @friend_requests ||= ::Users::UserFriendRequestsQuery.all(user, queries)
        end

        def received_friend_requests
          @received_friend_requests ||= ::Users::UserReceivedFriendRequestsQuery.all(user, queries)
        end

        def user
          @parent ||= User.find(params[:user_id])
        end
      end
    end
  end
end
