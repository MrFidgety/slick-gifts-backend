# frozen_string_literal: true

module FriendRequests
  class << self
    def create_friend_request(*args)
      FriendRequests::CreateFriendRequest.perform(*args)
    end

    def accept_friend_request(*args)
      FriendRequests::AcceptFriendRequest.perform(*args)
    end

    def cancel_friend_request(*args)
      FriendRequests::CancelFriendRequest.perform(*args)
    end
  end
end
