# frozen_string_literal: true

module Api
  module V1
    class FriendshipsController < ApiController
      authorize action: :destroy, auths: { resource: :destroy }

      def destroy
        action = Friendships.destroy_friendship(resource)

        if action.success?
          head :no_content
        else
          render_unprocessable action
        end
      end

      private

      def resource
        @resource ||= Friendship.find(params[:id])
      end
    end
  end
end
