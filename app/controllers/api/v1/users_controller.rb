# frozen_string_literal: true

require "params_plus"

module Api
  module V1
    class UsersController < ApiController
      skip_authentication_for :create

      def create
        action = ::Users.create_user(user_attributes)

        if action.success?
          respond_with action.user,
                       include: %w[sessions],
                       links: { self: api_v1_users_me_url }
        else
          render_unprocessable action
        end
      end

      private

        def user_attributes
          @user_attributes ||= params_plus.form_attributes.to_hash
        end

        def params_plus
          @params_plus ||= ParamsPlus.new(params)
        end
    end
  end
end