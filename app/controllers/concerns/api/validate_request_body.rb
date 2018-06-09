# frozen_string_literal: true

require 'active_support/concern'

module Api
  module ValidateRequestBody
    extend ActiveSupport::Concern

    included do
      before_action :validate_type, only: %i[create update]
      before_action :validate_id, only: :update

      private

      def validate_type
        return unless params['data'].present?

        render_errors(Renderror::JsonapiConflict.new) unless type_matches?
      end

      def type_matches?
        params['data'].try(:[], 'type') == jsonapi_type
      end

      # This can be overwritten on a per-controller basis if the type name
      # doesn't match the controller name
      def jsonapi_type
        controller_name.dasherize
      end

      def validate_id
        return unless params['data'].present?
        return if id_matches?

        render_errors(
          Renderror::JsonapiConflict.new(
            detail: I18n.t(:"renderror.conflict.id_mismatch")
          )
        )
      end

      def id_matches?
        params.dig(:data, :id) == params[:id]
      end

      def deserialize(params, options = {})
        ActiveModelSerializers::Deserialization.jsonapi_parse!(
          params, options
        )
      end
    end
  end
end
