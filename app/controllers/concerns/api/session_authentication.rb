# frozen_string_literal: true

require 'active_support/concern'

module Api
  module SessionAuthentication
    extend ActiveSupport::Concern

    included do
      acts_as_token_authentication_handler_for_session
    end

    class_methods do
      def acts_as_token_authentication_handler_for_session(skip: nil)
        acts_as_token_authentication_handler_for DeviseSessionable::Session,
                                                 as: :session,
                                                 fallback: :exception,
                                                 except: skip
      end

      def skip_authentication_for(*actions)
        acts_as_token_authentication_handler_for_session(skip: actions)
      end
    end

    private

      def current_authable
        current_user
      end
  end
end
