# frozen_string_literal: true

require "active_support/concern"

module Api
  module TopLevelMeta
    extend ActiveSupport::Concern

    included do
      class_attribute :registered_metadata
      self.registered_metadata = {}
      add_response_options :all, :meta

      def meta(_action, resource)
        self.class.registered_metadata.inject({}) do |acc, (k, v)|
          value = send(v, resource)

          if value.present?
            acc.merge(k => value)
          else
            acc
          end
        end
      end

      class << self
        def register_meta(key, value)
          registered_metadata.merge!(key => value)
        end
      end
    end
  end
end
