# frozen_string_literal: true

module FriendRequests
  class << self
    def create_friend_request(*args)
      FriendRequests::CreateFriendRequest.perform(*args)
    end
  end
end
