# frozen_string_literal: true

require 'reform/form/dry'

class BlockadeForm < Reform::Form
  feature Dry

  property :user, populator: (lambda do |options|
    self.user = User.find(options[:fragment][:id])
  end)

  property :blocked, populator: (lambda do |options|
    self.blocked = User.find(options[:fragment][:id])
  end)

  validation :default do
    configure do
      option :form

      def different_user?(value)
        value != form.user
      end

      def blockade_unique?(value)
        !Blockade.where(user: form.user, blocked: value).exists?
      end
    end

    required(:user).filled
    required(:blocked).filled(:different_user?, :blockade_unique?)
  end
end
