# frozen_string_literal: true

module Blockades
  class DestroyBlockade
    include UseCase

    def initialize(blockade)
      @blockade = blockade
    end

    def perform
      destroy_blockade
    end

    private

    attr_reader :blockade

    def destroy_blockade
      blockade.destroy.tap do |success|
        add_error_to_base('Failed to unblock user') unless success
      end
    end
  end
end
