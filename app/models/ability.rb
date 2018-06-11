# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(authable)
    can :destroy, DeviseSessionable::Session, authable_id: authable.id
    can :accept, FriendRequest do |friend_request|
      authable == friend_request.friend
    end
  end
end
