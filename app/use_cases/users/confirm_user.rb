# frozen_string_literal: true

module Users
  class ConfirmUser
    include UseCase

    attr_reader :session

    def initialize(attributes)
      @attributes = attributes
    end

    def perform
      ActiveRecord::Base.transaction do
        confirm_user_by_token
        create_session
      end
    end

    private

      attr_reader :attributes
      attr_reader :user

      def confirm_user_by_token
        User.confirm_by_token(attributes[:confirmation_token]).tap do |user|
          @user = user

          unless user.errors.empty?
            error_and_rollback('Failed to confirm user', user.errors)
          end
        end
      end

      def create_session
        DeviseSessionable::Session.create(authable: user).tap do |session|
          @session = session

          error_and_rollback('Failed to create session') unless session
        end
      end
  end
end
