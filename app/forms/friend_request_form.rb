# frozen_string_literal: true

require 'reform/form/dry'

class FriendRequestForm < Reform::Form
  feature Dry

  property :user, populator: (lambda do |options|
    self.user = User.find(options[:fragment][:id])
  end)

  property :friend, populator: (lambda do |options|
    self.friend = User.find(options[:fragment][:id])
  end)

  validation :default do
    configure do
      option :form

      def different_user?(value)
        value != form.user
      end

      def request_unique?(value)
        !FriendRequest.where(user: form.user, friend: value).exists?
      end

      def not_friends?(value)
        !Friendship.where(user: form.user, friend: value).exists?
      end
    end

    required(:user).filled
    required(:friend).filled(:different_user?, :request_unique?, :not_friends?)
  end
end
