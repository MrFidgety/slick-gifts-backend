# frozen_string_literal: true

module FriendRequests
  class AcceptFriendRequest
    include UseCase

    attr_reader :friendship

    def initialize(friend_request)
      @friend_request = friend_request
      @accepting_user = friend_request.friend
      @friend = friend_request.user
    end

    def perform
      ActiveRecord::Base.transaction do
        friend_request.accept
        fetch_new_friendship
      end
    end

    private

    attr_reader :friend_request
    attr_reader :accepting_user
    attr_reader :friend

    def fetch_new_friendship
      @friendship = accepting_user.friendships.find_by!(friend: friend)
    rescue ActiveRecord::RecordNotFound
      error_and_rollback('Failed to accept friend request')
    end
  end
end
