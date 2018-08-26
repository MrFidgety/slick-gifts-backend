# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      skip_authentication_for :create

      enable_pagination_for :index

      def create
        action = ::Users.create_user(user_attributes)

        if action.success?
          respond_with action.user
        else
          render_unprocessable action
        end
      end

      def index
        respond_with user_search_result,
                     each_serializer: ::Users::PublicUserSerializer
      end

      private

      def user_attributes
        @user_attributes ||= params_plus.form_attributes.to_hash
      end

      def params_plus
        @params_plus ||= ParamsPlus.new(params)
      end

      def user_search_result
        @user_search_result ||= UsersQuery.all(params[:search], queries)
      end
    end
  end
end
