# frozen_string_literal: true

module Api
  module V1
    class BlockadesController < ApiController
      authorize action: :destroy, auths: { resource: :destroy }

      def create
        action = Blockades.create_blockade(blockade_attributes)

        if action.success?
          respond_with action.blockade
        else
          render_unprocessable action
        end
      end

      def destroy
        action = Blockades.destroy_blockade(resource)

        if action.success?
          head :no_content
        else
          render_unprocessable action
        end
      end

      private

      def resource
        @resource ||= Blockade.find(params[:id])
      end

      def blockade_attributes
        @blockade_attributes ||= params_plus.form_attributes
                                            .transform(add_user)
                                            .to_hash
      end

      def params_plus
        @params_plus ||= ParamsPlus.new(params, belongs_to: %w[user blocked])
      end

      def add_user
        lambda do |attrs|
          attrs.merge(user: { id: current_user.id })
        end
      end
    end
  end
end
