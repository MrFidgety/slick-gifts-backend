# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(authable)
    can :destroy, DeviseSessionable::Session, authable_id: authable.id
    can :accept, FriendRequest do |request|
      authable == request.friend
    end
    can :destroy, FriendRequest do |request|
      [request.user, request.friend].include? authable
    end
    can :destroy, Friendship do |friendship|
      authable == friendship.user
    end
    can :list_friends, User do |user|
      authable == user || authable.friends.exists?(user.id)
    end
  end
end
