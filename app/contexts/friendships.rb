# frozen_string_literal: true

module Friendships
  class << self
    def destroy_friendship(*args)
      Friendships::DestroyFriendship.perform(*args)
    end
  end
end
