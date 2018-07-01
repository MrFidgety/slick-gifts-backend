# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendRequests::CreateFriendRequest do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }

  let(:friend_request_attributes) do
    {
      user: { id: user.id },
      friend: { id: friend.id }
    }
  end

  subject { described_class.new(friend_request_attributes) }
  let(:perform) { subject.tap(&:perform) }

  describe 'Success' do
    it { is_expected.to perform_successfully }

    it 'creates a friend request' do
      expect { perform }.to change(FriendRequest, :count).by 1
    end

    it 'exposes the friend request' do
      expect(perform.friend_request).to be_a FriendRequest
    end
  end

  describe 'invalid friend request attributes' do
    let(:form_errors) do
      Reform::Contract::Errors.new.tap do |e|
        e.add(:friend, 'cannot be yourself')
      end
    end

    let(:failure_case) do
      instance_double(
        'FriendRequestForm',
        validate: false,
        model: FriendRequest.new,
        errors: form_errors,
      )
    end

    before do
      allow(FriendRequestForm).to receive(:new).and_return(failure_case)
    end

    it { is_expected.to_not perform_successfully }

    it 'does not create a friend request' do
      expect { perform }.not_to change(FriendRequest, :count)
    end

    it 'adds the form errors to the use case' do
      expect(perform.errors[:friend]).to include 'cannot be yourself'
    end

    it 'adds a base error to the use case' do
      expect(perform.errors[:base]).to include 'Failed to save friend request'
    end
  end

  describe 'failure to save friend request' do
    before do
      allow_any_instance_of(FriendRequest).to receive(:save) { false }
    end

    it { is_expected.to_not perform_successfully }

    it 'adds a base error to the use case' do
      expect(perform.errors[:base]).to include 'Failed to save friend request'
    end
  end
end
