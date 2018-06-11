# frozen_string_literal: true

module FriendRequests
  class CancelFriendRequest
    include UseCase

    def initialize(friend_request)
      @friend_request = friend_request
    end

    def perform
      cancel_friend_request
    end

    private

    attr_reader :friend_request

    def cancel_friend_request
      friend_request.destroy.tap do |success|
        add_error_to_base('Failed to delete friend request') unless success
      end
    end
  end
end
