# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Sessions', type: :request do
  describe 'POST sessions' do
    before { request_path '/api/v1/sessions' }

    let!(:user) { create(:user) }

    let(:session_attributes) do
      {
        access_type: 'password',
        passkey: user.email,
        passcode: user.password
      }
    end

    let(:params) { post_body('sessions', session_attributes) }

    subject { do_post params: params }

    it 'Success creates a new session' do
      expect { subject }.to change(DeviseSessionable::Session, :count).by 1

      expect(response).to have_http_status :created
      expect(response).to match_primary_type 'sessions'
      expect(response).to render_included_resource user
    end

    it_behaves_like 'request endpoint with data validation'

    it_behaves_like 'request with failed action returns unprocessable' do
      before { session_attributes[:passcode] = '' }

      let(:error_detail) { I18n.t(:'devise.auth.password.failure') }
      let(:error_pointer) {}
    end
  end

  describe 'DELETE sessions/{id}' do
    before { request_path "/api/v1/sessions/#{id}" }

    let!(:session) { create(:session) }
    let(:headers) { auth_headers_for_session(session) }
    let(:id) { session.id }

    subject { do_delete headers: headers }

    it 'Success destroys the session' do
      expect { subject }.to change(DeviseSessionable::Session, :count).by(-1)

      expect(response).to have_http_status :no_content
    end

    it_behaves_like 'request requires token authentication'
    it_behaves_like 'request requires authorization'

    it_behaves_like 'request with non-existent resource returns not found' do
      let(:id) { 'foobar' }
    end
  end
end
