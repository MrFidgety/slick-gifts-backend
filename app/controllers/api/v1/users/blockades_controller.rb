# frozen_string_literal: true

module Api
  module V1
    module Users
      class BlockadesController < ApiController
        authorize action: :index, auths: { user: :list_blockades }

        enable_pagination_for :index

        enable_inclusions_for index: %i[blocked]

        def index
          respond_with blockades,
                       include: included_resources,
                       links: { self: api_v1_user_blockades_url(user) }
        end

        private

        def blockades
          @blockades ||= ::Users::UserBlockadesQuery.all(user, queries)
        end

        def user
          @parent ||= User.find(params[:user_id])
        end
      end
    end
  end
end
