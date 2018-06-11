# frozen_string_literal: true

require 'active_support/concern'

module Api
  module Pagination
    extend ActiveSupport::Concern

    included do
      before_action :ensure_pagination_enabled
      before_action :validate_pagination_params

      private

      def pagination_requested
        return {} unless params[:page].present?
        { number: page_number, size: page_size }
      end

      def page_number
        params.dig(:page, :number)&.to_i
      end

      def page_size
        params.dig(:page, :size)&.to_i
      end

      def validate_pagination_params
        return if params[:page].blank? || pagination_valid?
        raise ActionController::BadRequest, 'Pagination params invalid'
      end

      def pagination_valid?
        valid_pagination_keys? && valid_pagination_strategy?
      end

      def valid_pagination_keys?
        params[:page].respond_to?(:keys) &&
          params[:page].keys.all? { |k| %w[size number].include? k }
      end

      def valid_pagination_strategy?
        params.dig(:page, :size) || params.dig(:page, :number)
      end

      def ensure_pagination_enabled
        return if params[:page].blank? || pagination_enabled?

        raise ActionController::BadRequest, 'Pagination is not permitted here'
      end

      def pagination_enabled?
        paginatable_actions.include?(params[:action])
      end

      def paginatable_actions
        []
      end

      def pagination_total_pages(collection)
        return nil unless collection.respond_to? :total_pages

        collection.total_pages
      end

      def pagination_total_objects(collection)
        return nil unless collection.respond_to? :total_count

        collection.total_count
      end

      class << self
        def register_pagination_meta
          register_meta('total-pages', :pagination_total_pages)
          register_meta('total-objects', :pagination_total_objects)
        end

        def enable_pagination_for(*actions)
          define_method(:paginatable_actions) { actions.map(&:to_s) }
          private :paginatable_actions
          register_pagination_meta
        end
      end
    end
  end
end
