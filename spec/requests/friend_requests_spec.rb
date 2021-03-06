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

  describe 'POST friend-requests/{id}/accept' do
    before { request_path "/api/v1/friend-requests/#{id}/accept" }

    let(:accepting_user) { create(:user, :with_session) }
    let!(:friend_request) { create(:friend_request, friend: accepting_user) }
    let(:id) { friend_request.id }
    let(:params) { default_params }
    let(:headers) { auth_headers_for_user(accepting_user) }

    subject { do_post params: params, headers: headers }

    it 'Success accepts the friend request' do
      expect { subject }.to change(friend_request.user.friends, :count).by 1

      expect(response).to have_http_status :created
      expect(response).to match_primary_type 'friendships'
    end

    it_behaves_like 'request requires token authentication'
    it_behaves_like 'request requires authorization'

    it_behaves_like 'request with non-existent resource returns not found' do
      let(:id) { 'foobar' }
    end
  end

  describe 'DELETE friend-requests/{id}' do
    before { request_path "/api/v1/friend-requests/#{id}" }

    let(:user) { create(:user, :with_session) }
    let!(:friend_request) { create(:friend_request, user: user) }
    let(:id) { friend_request.id }
    let(:params) { default_params }
    let(:headers) { auth_headers_for_user(user) }

    subject { do_delete params: params, headers: headers }

    it 'Success destroys the friend request' do
      expect { subject }.to change(FriendRequest, :count).by(-1)

      expect(response).to have_http_status :no_content
    end

    it_behaves_like 'request requires token authentication'
    it_behaves_like 'request requires authorization'

    it_behaves_like 'request with non-existent resource returns not found' do
      let(:id) { 'foobar' }
    end
  end

  describe 'GET user/{id}/friend-requests/sent' do
    before { request_path "/api/v1/users/#{id}/friend-requests/sent" }

    let!(:user) { create(:user, :with_session) }
    let!(:friend_requests) { create_list(:friend_request, 3, user: user) }
    let(:id) { user.id }

    let(:params) { {} }
    let(:headers) { auth_headers_for_user(user) }

    subject { do_get params: params, headers: headers }

    it 'Success lists the users friend requests' do
      subject

      expect(response).to have_http_status :ok
      expect(response).to render_primary_resources friend_requests
      expect(response).to have_top_level_links(self: "/users/#{id}/friend-requests/sent")
    end

    describe 'resource inclusion' do
      let(:inclusions) { %i[friend] }

      let(:related) do
        inclusions.each_with_object({}) do |inc, memo|
          memo[inc] = friend_requests.map(&inc)
        end
      end

      before do
        params[:include] = inclusions.join(',').dasherize
        subject
      end

      it 'can include friends' do
        expect(response).to render_included_resources related[:friend]
      end
    end

    it_behaves_like 'request with invalid inclusions returns bad request'
    it_behaves_like 'request permits pagination'
    it_behaves_like 'request requires token authentication'
    it_behaves_like 'request requires authorization'

    it_behaves_like 'request with non-existent resource returns not found' do
      let(:id) { 'foobar' }
    end
  end

  describe 'GET user/{id}/friend-requests/received' do
    before { request_path "/api/v1/users/#{id}/friend-requests/received" }

    let!(:user) { create(:user, :with_session) }
    let!(:friend_requests) { create_list(:friend_request, 3, friend: user) }
    let(:id) { user.id }

    let(:params) { {} }
    let(:headers) { auth_headers_for_user(user) }

    subject { do_get params: params, headers: headers }

    it 'Success lists the users received friend requests' do
      subject

      expect(response).to have_http_status :ok
      expect(response).to render_primary_resources friend_requests
      expect(response).to have_top_level_links(self: "/users/#{id}/friend-requests/received")
    end

    describe 'resource inclusion' do
      let(:inclusions) { %i[user] }

      let(:related) do
        inclusions.each_with_object({}) do |inc, memo|
          memo[inc] = friend_requests.map(&inc)
        end
      end

      before do
        params[:include] = inclusions.join(',').dasherize
        subject
      end

      it 'can include users' do
        expect(response).to render_included_resources related[:user]
      end
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
