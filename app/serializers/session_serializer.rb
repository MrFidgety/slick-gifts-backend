# frozen_string_literal: true

class SessionSerializer < ActiveModel::Serializer
  type 'sessions'

  attributes :id, :authentication_token

  has_one :authable
end
