# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendRequests::AcceptFriendRequest do
  let(:accepting_user) { create(:user, :with_session) }
  let!(:friend_request) { create(:friend_request, friend: accepting_user) }

  subject { described_class.new(friend_request) }
  let(:perform) { subject.tap(&:perform) }

  describe 'Success' do
    it { is_expected.to perform_successfully }

    it 'creates a friendship for both users' do
      expect { perform }.to change(Friendship, :count).by 2
    end

    it 'destroys the friend request' do
      expect { perform }.to change(FriendRequest, :count).by(-1)
    end

    it 'exposes the accepting users friendship' do
      friendship = perform.friendship

      expect(accepting_user.friendships).to include friendship
    end
  end

  describe 'failure to save friendship' do
    before do
      allow_any_instance_of(Friendship).to receive(:save) { false }
    end

    it { is_expected.to_not perform_successfully }

    it 'does not destroy the friend request' do
      expect { perform }.not_to change(FriendRequest, :count)
    end

    it 'adds a base error to the use case' do
      expect(perform.errors[:base]).to include 'Failed to accept friend request'
    end
  end
end
