# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::FriendRequestsController, type: :controller do
  describe 'POST create' do
    before { request_action :create }

    let(:user) { build_with_id(:user) }
    let(:friend) { build_with_id(:user) }

    let(:relationships) do
      { friend: { type: 'users', id: friend.id } }
    end

    let(:friend_request) do
      build_with_id(:friend_request, user: user, friend: friend)
    end

    let(:create_action) do
      instance_double(
        'FriendRequests::CreateFriendRequest',
        success?: true,
        friend_request: friend_request
      )
    end

    let(:expected_attributes) do
      {
        user: { id: user.id },
        friend: { id: friend.id }
      }
    end

    let(:params) { post_body('friend-requests', {}, relationships) }

    subject { post :create, params: params }

    before do
      authenticate_as(user)
      allow(FriendRequests).to receive(:create_friend_request)
        .with(expected_attributes)
        .and_return(create_action)
    end

    describe 'Success' do
      it { is_expected.to have_http_status :created }
      it { is_expected.to render_primary_resource friend_request }

      it 'creates the friend request' do
        expect(FriendRequests).to receive(:create_friend_request)
          .with(expected_attributes)

        subject
      end

      it 'ignores user id if present in params' do
        relationships[:user] = { type: 'users', id: build_with_id(:user).id }

        expect(FriendRequests).to receive(:create_friend_request)
          .with(expected_attributes)

        subject
      end
    end

    it_behaves_like 'a data validation action'
    it_behaves_like 'an authenticated endpoint'

    it_behaves_like 'non-existent resource returns not found' do
      before do
        allow(FriendRequests).to receive(:create_friend_request)
          .and_raise(ActiveRecord::RecordNotFound)
      end
    end

    it_behaves_like 'an unprocessable action',
                    FriendRequests, :create_friend_request
  end
end
