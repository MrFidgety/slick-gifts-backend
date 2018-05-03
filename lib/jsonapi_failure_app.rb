# frozen_string_literal: true

class JsonapiFailureApp < Devise::FailureApp
  def respond
    if request.format == :json
      render_jsonapi_unauthorized
    else
      super
    end
  end

  def render_jsonapi_unauthorized
    self.status = :unauthorized
    self.content_type = 'application/vnd.api+json'
    self.response_body = {
      'errors' => [{
        'status' => '401',
        'title' => I18n.t(:'renderror.unauthorized.title'),
        'detail' => I18n.t(:'renderror.unauthorized.detail')
      }]
    }.to_json
  end
end
