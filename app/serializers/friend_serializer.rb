# frozen_string_literal: true

class FriendSerializer < ActiveModel::Serializer
  type 'users'

  attributes :id
end
