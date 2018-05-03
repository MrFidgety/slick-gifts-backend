# frozen_string_literal: true

module Sessions
  class CreateSession
    include UseCase

    VALID_ACCESS_TYPES = %w[password].freeze

    attr_reader :session

    def initialize(attributes)
      @access_type = attributes[:access_type]
      @passkey = attributes[:passkey]
      @passcode = attributes[:passcode]
    end

    def perform
      create_session if valid_type? && authenticated_user?
    end

    private

      attr_reader :access_type
      attr_reader :passkey
      attr_reader :passcode

      def valid_type?
        VALID_ACCESS_TYPES.include?(access_type).tap do |success|
          add_error_to_base(I18n.t(:"devise.auth.invalid_type")) unless success
        end
      end

      def authenticated_user?
        (user.present? && user.valid_password?(passcode)).tap do |success|
          unless success
            add_error_to_base(I18n.t(:"devise.auth.password.failure"))
          end
        end
      end

      def create_session
        DeviseSessionable::Session.create(authable: user).tap do |session|
          @session = session

          add_error_to_base('Failed to create session') unless session
        end
      end

      def user
        @user ||= User.find_for_database_authentication(email: passkey)
      end
  end
end
