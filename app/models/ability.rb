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
  end
end
