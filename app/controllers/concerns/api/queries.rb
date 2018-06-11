# frozen_string_literal: true

require 'active_support/concern'

module Api
  module Queries
    extend ActiveSupport::Concern

    included do
      def queries
        {
          page: pagination_requested,
          includes: included_resources
        }
      end
    end
  end
end
