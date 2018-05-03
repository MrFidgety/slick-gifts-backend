# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      respond_to :json
      responders :json

      renderror_auto_rescue :bad_request, :cancan, :not_found,
                            :invalid_document, :conflict

      include Api::SessionAuthentication
      include Api::AuthorizeResources
      include Api::ValidateRequestBody
      include Api::ResponseOptions
      include Api::TopLevelMeta
    end
  end
end
