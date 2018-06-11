# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Friendships', type: :request do
  describe 'DELETE friendships/{id}' do
    before { request_path "/api/v1/friendships/#{id}" }

    let(:user) { create(:user, :with_session) }
    let!(:friendship) { create(:friendship, user: user) }
    let(:id) { friendship.id }
    let(:params) { default_params }
    let(:headers) { auth_headers_for_user(user) }

    subject { do_delete params: params, headers: headers }

    it 'Success destroys the friendship for both users' do
      expect { subject }.to change(Friendship, :count).by(-2)

      expect(response).to have_http_status :no_content
    end

    it_behaves_like 'request requires token authentication'
    it_behaves_like 'request requires authorization'

    it_behaves_like 'request with non-existent resource returns not found' do
      let(:id) { 'foobar' }
    end
  end
end
