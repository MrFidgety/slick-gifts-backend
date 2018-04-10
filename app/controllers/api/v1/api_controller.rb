# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      respond_to :json
      responders :json

      include Api::SessionAuthentication

      private

        def current_authable
          current_user
        end
    end
  end
end
