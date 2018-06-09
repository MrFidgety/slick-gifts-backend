# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApiController
      skip_authentication_for :create

      authorize action: :destroy, auths: { resource: :destroy }

      def create
        action = ::Sessions.create_session(session_attributes)

        if action.success?
          respond_with action.session,
                       include: %w[authable]
        else
          render_unprocessable action
        end
      end

      def destroy
        render_unprocessable resource unless resource.destroy
      end

      private

      def session_attributes
        @session_attributes ||= deserialize(
          params, only: %w[access-type passkey passcode]
        )
      end

      def resource
        @resource ||= DeviseSessionable::Session.find(params[:id])
      end
    end
  end
end
