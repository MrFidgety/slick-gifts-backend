# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      respond_to :json
      responders :json

      renderror_auto_rescue :bad_request, :cancan, :not_found,
                            :invalid_document, :conflict

      include Api::AuthorizeResources
      include Api::Pagination
      include Api::Queries
      include Api::RelatedResourceInclusion
      include Api::ResponseOptions
      include Api::SessionAuthentication
      include Api::TopLevelMeta
      include Api::ValidateRequestBody
    end
  end
end
