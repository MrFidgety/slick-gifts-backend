# frozen_string_literal: true

module Api
  module V1
    module Users
      class FriendsController < ApiController
        authorize action: :index, auths: { user: :list_friends }

        enable_pagination_for :index

        def index
          respond_with friends,
                       include: included_resources,
                       links: { self: api_v1_user_friends_url(user) }
        end

        private

        def friends
          @friends ||= ::Users::UserFriendsQuery.all(user, queries)
        end

        def user
          @parent ||= User.find(params[:user_id])
        end
      end
    end
  end
end
