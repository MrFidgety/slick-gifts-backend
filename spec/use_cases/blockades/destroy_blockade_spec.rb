# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Blockades::DestroyBlockade do
  let!(:blockade) { create(:blockade) }

  subject { described_class.new(blockade) }
  let(:perform) { subject.tap(&:perform) }

  describe 'Success' do
    it { is_expected.to perform_successfully }

    it 'destroys the blockade' do
      expect { perform }.to change(Blockade, :count).by(-1)
    end
  end

  describe 'failure to destroy blockade' do
    before do
      allow_any_instance_of(Blockade).to receive(:destroy) { false }
    end

    it { is_expected.to_not perform_successfully }

    it 'does not destroy the blockade' do
      expect { perform }.not_to change(Blockade, :count)
    end

    it 'adds a base error to the use case' do
      expect(perform.errors[:base]).to include 'Failed to unblock user'
    end
  end
end
