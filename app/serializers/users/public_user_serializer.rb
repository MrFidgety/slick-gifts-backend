# frozen_string_literal: true

module Users
  class PublicUserSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :username
  end
end
