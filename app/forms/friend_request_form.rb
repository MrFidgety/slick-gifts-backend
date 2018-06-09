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
    end

    required(:user).filled
    required(:friend).filled(:different_user?)
  end
end
