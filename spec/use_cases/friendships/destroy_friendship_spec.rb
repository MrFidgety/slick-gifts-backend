# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendships::DestroyFriendship do
  let!(:friendship) { create(:friendship) }

  subject { described_class.new(friendship) }
  let(:perform) { subject.tap(&:perform) }

  describe 'Success' do
    it { is_expected.to perform_successfully }

    it 'destroys the friendship for both users' do
      expect { perform }.to change(Friendship, :count).by(-2)
    end
  end

  describe 'failure to destroy friendship' do
    before do
      allow_any_instance_of(Friendship).to receive(:destroy) { false }
    end

    it { is_expected.to_not perform_successfully }

    it 'does not destroy the friendship' do
      expect { perform }.not_to change(Friendship, :count)
    end

    it 'adds a base error to the use case' do
      expect(perform.errors[:base]).to include 'Failed to delete friendship'
    end
  end
end
