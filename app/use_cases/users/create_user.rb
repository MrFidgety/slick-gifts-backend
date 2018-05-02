# frozen_string_literal: true

module Users
  class CreateUser
    include UseCase

    attr_reader :user

    def initialize(attributes)
      @attributes = attributes
    end

    def perform
      init_form
      save_user

      resend_confirmation if should_resend_confirmation?
    end

    private

      attr_reader :attributes
      attr_reader :form
      attr_reader :unconfirmed_user

      def init_form
        @form = UserForm.new(find_unconfirmed_user || User.new)
      end

      def save_user
        form.validate(attributes).tap do |success|
          @user = form.model

          unless success && form.save
            add_error_to_base('Failed to save user', form.errors)
          end
        end
      end

      def find_unconfirmed_user
        @unconfirmed_user = User.find_by(
          email: attributes[:email], confirmed_at: nil
        )
      end

      def should_resend_confirmation?
        unconfirmed_user.present? && not_sent_recently?
      end

      def not_sent_recently?
        (Time.current - unconfirmed_user.confirmation_sent_at) > 1.minute
      end

      def resend_confirmation
        unconfirmed_user.send_confirmation_instructions
      end
  end
end
