# frozen_string_literal: true

module Blockades
  class CreateBlockade
    include UseCase

    attr_reader :blockade

    def initialize(attributes)
      @attributes = attributes
    end

    def perform
      init_form
      save_blockade
    end

    private

    attr_reader :attributes
    attr_reader :form

    def init_form
      @form = BlockadeForm.new(Blockade.new)
    end

    def save_blockade
      form.validate(attributes).tap do |success|
        @blockade = form.model

        unless success && form.save
          add_error_to_base('Failed to block user', form.errors)
        end
      end
    end
  end
end
