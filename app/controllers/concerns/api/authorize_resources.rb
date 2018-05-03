# frozen_string_literal: true

require 'active_support/concern'

module Api
  module AuthorizeResources
    extend ActiveSupport::Concern

    included do
      class_attribute :authorization_rules
      self.authorization_rules = {}

      private

        def authorize_resources
          return unless authorization_rules.key? action_name.to_sym

          rules.each do |resource, ability|
            [*send(resource)].each { |r| authorize! ability, r, message: message }
          end
        end

        def related_model
          controller_name.classify.constantize
        end

        def rules
          authorization_rules[action_name.to_sym][:auths]
        end

        def message
          authorization_rules[action_name.to_sym][:message]
        end
    end

    class_methods do
      def authorize(action:, auths:, message: nil)
        before_action :authorize_resources

        self.authorization_rules = authorization_rules.deep_merge(
          action => { auths: auths, message: message }
        )
      end
    end
  end
end
