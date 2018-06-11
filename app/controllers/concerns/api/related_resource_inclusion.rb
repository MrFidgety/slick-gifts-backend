# frozen_string_literal: true

require 'active_support/concern'

module Api
  module RelatedResourceInclusion
    extend ActiveSupport::Concern

    included do
      before_action :ensure_inclusions_enabled
      before_action :validate_inclusions

      private

      def valid_inclusion_actions
        []
      end

      def ensure_inclusions_enabled
        return if params[:include].blank? || inclusions_enabled?

        raise ActionController::BadRequest,
              'Related resource inclusion is not permitted here'
      end

      def inclusions_enabled?
        valid_inclusion_actions.include? params[:action]
      end

      def included_resources
        return %w[] unless params[:include]

        resources_requested
      end

      def validate_inclusions
        return if params[:include].blank? || inclusions_valid?
        raise ActionController::BadRequest, 'Inclusions invalid'
      end

      def resources_requested
        return [] unless params[:include]

        params[:include].split(',').map(&:underscore)
      end

      def inclusions_valid?
        all_permitted?
      end

      def all_permitted?
        resources_requested.all? do |param|
          permitted_inclusions_for_action.include? param
        end
      end

      def permitted_inclusions_for_action
        action = valid_inclusion_actions.find { |a| a == params[:action] }
        raise ActionController::BadRequest unless action.present?

        send("valid_#{action}_inclusion_fields")
      end

      class << self
        def enable_inclusions_for(actions = {})
          define_method(:valid_inclusion_actions) { actions.keys.map(&:to_s) }
          private :valid_inclusion_actions

          define_action_specific_inclusions(actions)
        end

        def define_action_specific_inclusions(actions)
          actions.each do |action, fields|
            define_method("valid_#{action}_inclusion_fields") do
              fields.map(&:to_s)
            end
            private "valid_#{action}_inclusion_fields"
          end
        end
      end
    end
  end
end
