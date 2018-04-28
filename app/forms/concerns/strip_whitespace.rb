# frozen_string_literal: true

require 'active_support/concern'

module StripWhitespace
  extend ActiveSupport::Concern

  included do
    class << self
      def strip_whitespace(*attributes)
        attributes.to_a.each do |attr|
          define_method("#{attr}=") do |value|
            super(value&.strip)
          end
        end
      end
    end
  end
end
