# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::FriendshipsController, type: :controller do
  describe 'DELETE destroy' do
    before { request_action :destroy }

    let(:user) { build_with_id(:user) }

    let(:friendship) do
      build_with_id(:friendship, user: user)
    end

    let(:destroy_action) do
      instance_double(
        'Friendships::DestroyFriendship',
        success?: true
      )
    end

    let(:params) { default_params.merge(id: friendship.id) }

    subject { delete :destroy, params: params }

    before do
      authenticate_as(user)

      allow(Friendship).to receive(:find)
        .with(friendship.id)
        .and_return(friendship)

      allow(Friendships).to receive(:destroy_friendship)
        .with(friendship)
        .and_return(destroy_action)
    end

    describe 'Success' do
      it { is_expected.to have_http_status :no_content }

      it 'destroys the friendship' do
        expect(Friendships).to receive(:destroy_friendship)
          .with(friendship)

        subject
      end
    end

    it_behaves_like 'an authenticated endpoint'
    it_behaves_like 'authorization is required'

    it_behaves_like 'non-existent resource returns not found' do
      before do
        allow(Friendship).to receive(:find)
          .with(friendship.id)
          .and_raise(ActiveRecord::RecordNotFound)
      end
    end

    it_behaves_like 'an unprocessable action',
                    Friendships, :destroy_friendship
  end
end
