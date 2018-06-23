# frozen_string_literal: true

module Users
  class UserReceivedFriendRequestsQuery < Query
    def initialize(user, page: {}, includes: [])
      @user = user
      @page = page
      @included_resources = includes
    end

    def all
      FriendRequest.where(friend: user)
                   .includes(included_resources)
                   .order(created_at: :desc)
                   .page(page_number)
                   .per(page_size)
    end

    private

    attr_reader :user
  end
end
