# frozen_string_literal: true

module Friendships
  class DestroyFriendship
    include UseCase

    def initialize(friendship)
      @friendship = friendship
    end

    def perform
      destroy_friendship
    end

    private

    attr_reader :friendship

    def destroy_friendship
      friendship.destroy.tap do |success|
        add_error_to_base('Failed to delete friendship') unless success
      end
    end
  end
end
