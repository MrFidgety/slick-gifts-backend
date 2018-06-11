# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendRequests::CancelFriendRequest do
  let!(:friend_request) { create(:friend_request) }

  subject { described_class.new(friend_request) }
  let(:perform) { subject.tap(&:perform) }

  describe 'Success' do
    it { is_expected.to perform_successfully }

    it 'destroys the friend request' do
      expect { perform }.to change(FriendRequest, :count).by(-1)
    end
  end

  describe 'failure to destroy friend request' do
    before do
      allow_any_instance_of(FriendRequest).to receive(:destroy) { false }
    end

    it { is_expected.to_not perform_successfully }

    it 'does not destroy the friend request' do
      expect { perform }.not_to change(FriendRequest, :count)
    end

    it 'adds a base error to the use case' do
      expect(perform.errors[:base]).to include 'Failed to delete friend request'
    end
  end
end
