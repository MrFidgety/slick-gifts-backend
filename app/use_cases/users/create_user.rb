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
    end

    private

      attr_reader :attributes
      attr_reader :form

      def init_form
        @form = UserForm.new(User.new)
      end

      def save_user
        form.validate(attributes).tap do |success|
          @user = form.model

          unless success && form.save
            add_error_to_base("Failed to save user", form.errors)
          end
        end
      end
  end
end
