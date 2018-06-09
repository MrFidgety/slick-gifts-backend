# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::FriendRequests', type: :request do
  describe 'POST friend-requests' do
    before { request_path '/api/v1/friend-requests' }

    let!(:user) { create(:user, :with_session) }
    let!(:friend) { create(:user) }

    let(:relationships) do
      {
        friend: { type: 'users', id: friend.id }
      }
    end

    let(:params) { post_body('friend-requests', {}, relationships) }

    subject { do_post params: params, headers: auth_headers_for_user(user) }

    it 'Success creates a new friend request' do
      expect { subject }.to change(FriendRequest, :count).by 1

      expect(response).to have_http_status :created
      expect(response).to match_primary_type 'friend-requests'
    end

    it_behaves_like 'request endpoint with data validation'

    it_behaves_like 'request with failed action returns unprocessable' do
      before { relationships[:friend][:id] = user.id }

      let(:error_detail) { "Friend #{I18n.t(:"errors.different_user?")}" }
      let(:error_pointer) { '/data/attributes/friend' }
    end
  end
end
