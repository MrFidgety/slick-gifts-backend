# frozen_string_literal: true

require "params_plus"

module Api
  module V1
    module Users
      class ConfirmationsController < ApiController
        skip_authentication_for :show

        def show
          action = ::Users.confirm_user(confirmation_attributes)

          if action.success?
            respond_with action.session,
                         include: %w[authable]
          else
            render_unprocessable action
          end
        end

        private

          def confirmation_attributes
            params.permit(:confirmation_token).to_h
          end
      end
    end
  end
end
