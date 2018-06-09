# frozen_string_literal: true

module Api
  module V1
    class FriendRequestsController < ApiController
      def create
        action = FriendRequests.create_friend_request(friend_request_attributes)

        if action.success?
          respond_with action.friend_request
        else
          render_unprocessable action
        end
      end

      private

      def friend_request_attributes
        @friend_request_attributes ||= params_plus.form_attributes
                                              .transform(add_user)
                                              .to_hash
      end

      def params_plus
        @params_plus ||= ParamsPlus.new(params, belongs_to: %w[user friend])
      end

      def add_user
        lambda do |attrs|
          attrs.merge(user: { id: current_user.id })
        end
      end
    end
  end
end
