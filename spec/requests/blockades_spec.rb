# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Blockade', type: :request do
  describe 'POST blockades' do
    before { request_path '/api/v1/blockades' }

    let!(:user) { create(:user, :with_session) }
    let!(:blocked_user) { create(:user) }

    let(:relationships) do
      {
        blocked: { type: 'users', id: blocked_user.id }
      }
    end

    let(:params) { post_body('blockades', {}, relationships) }

    subject { do_post params: params, headers: auth_headers_for_user(user) }

    it 'Success creates a new blockade' do
      expect { subject }.to change(Blockade, :count).by 1

      expect(response).to have_http_status :created
    end

    it_behaves_like 'request endpoint with data validation'

    it_behaves_like 'request with failed action returns unprocessable' do
      before { relationships[:blocked][:id] = user.id }

      let(:error_detail) { "Blocked #{I18n.t(:"errors.different_user?")}" }
      let(:error_pointer) { '/data/attributes/blocked' }
    end
  end

  describe 'DELETE blockade/{id}' do
    before { request_path "/api/v1/blockades/#{id}" }

    let(:user) { create(:user, :with_session) }
    let!(:blockade) { create(:blockade, user: user) }
    let(:id) { blockade.id }
    let(:params) { default_params }
    let(:headers) { auth_headers_for_user(user) }

    subject { do_delete params: params, headers: headers }

    it 'Success destroys the blockade' do
      expect { subject }.to change(Blockade, :count).by(-1)

      expect(response).to have_http_status :no_content
    end

    it_behaves_like 'request requires token authentication'
    it_behaves_like 'request requires authorization'

    it_behaves_like 'request with non-existent resource returns not found' do
      let(:id) { 'foobar' }
    end
  end
end
