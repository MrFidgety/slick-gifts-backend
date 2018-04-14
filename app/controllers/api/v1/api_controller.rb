# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      respond_to :json
      responders :json

      renderror_auto_rescue :bad_request, :invalid_document

      include Api::SessionAuthentication
      include Api::ValidateRequestBody
      include Api::ResponseOptions
      include Api::TopLevelMeta

      private

        def current_authable
          current_user
        end
    end
  end
end
