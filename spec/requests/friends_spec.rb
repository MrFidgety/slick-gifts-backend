# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users::Friends', type: :request do
  describe 'GET friends' do
    before { request_path "/api/v1/users/#{id}/friends" }

    let!(:user) { create(:user, :with_session, :with_friends) }
    let(:friends) { user.friends.to_a }
    let(:id) { user.id }

    let(:params) { {} }
    let(:headers) { auth_headers_for_user(user) }

    subject { do_get params: params, headers: headers }

    it 'Success lists the users friends' do
      subject

      expect(response).to have_http_status :ok
      expect(response).to render_primary_resources friends
      expect(response).to have_top_level_links(self: "/users/#{id}/friends")
    end

    it_behaves_like 'request with invalid inclusions returns bad request'
    it_behaves_like 'request permits pagination'
    it_behaves_like 'request requires token authentication'
    it_behaves_like 'request requires authorization'

    it_behaves_like 'request with non-existent resource returns not found' do
      let(:id) { 'foobar' }
    end
  end
end
