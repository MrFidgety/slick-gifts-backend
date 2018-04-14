# frozen_string_literal: true

module Renderror
  class JsonapiConflict < Renderror::BaseError
    def status
      "409"
    end

    def default_title
      I18n.t(:"renderror.conflict.title")
    end

    def default_detail
      I18n.t(:"renderror.conflict.type_mismatch")
    end
  end
end
