# frozen_string_literal: true

require "active_support/concern"

module Api
  module ResponseOptions
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :response_modifiers

      def add_response_options(action, *methods)
        @response_modifiers ||= {}
        current_modifiers = response_modifiers[action] || []
        @response_modifiers[action] = current_modifiers + methods
      end

      def modifiers_for_action(action)
        @response_modifiers ||= {}

        response_modifiers.select do |k, _v|
          for_action?(k, action)
        end.values
      end

      def for_action?(k, action)
        k.to_s == action || k.to_s == "all"
      end
    end

    included do
      private

        def respond_with(resource, options = {})
          super(resource, response_options(resource, action_name)
            .deep_merge(options))
        end

        def response_options(resource, action)
          self.class.modifiers_for_action(action).reduce({}) do |acc, methods|
            modified_options(acc, methods, action, resource)
          end
        end

        def modified_options(base, methods, action, resource)
          methods.reduce(base) do |acc, method|
            acc.deep_merge(computed_option(method, action, resource))
          end
        end

        def computed_option(method, action, resource)
          send(method, action, resource)
        end
    end
  end
end
