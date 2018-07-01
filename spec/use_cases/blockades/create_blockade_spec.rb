# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Blockades::CreateBlockade do
  let(:user) { create(:user) }
  let(:blocked_user) { create(:user) }

  let(:blockade_attributes) do
    {
      user: { id: user.id },
      blocked: { id: blocked_user.id }
    }
  end

  subject { described_class.new(blockade_attributes) }
  let(:perform) { subject.tap(&:perform) }

  describe 'Success' do
    it { is_expected.to perform_successfully }

    it 'creates a blockade' do
      expect { perform }.to change(Blockade, :count).by 1
    end

    it 'exposes the blockade' do
      expect(perform.blockade).to be_a Blockade
    end
  end

  describe 'invalid blockade attributes' do
    let(:form_errors) do
      Reform::Contract::Errors.new.tap do |e|
        e.add(:blocked, 'cannot be yourself')
      end
    end

    let(:failure_case) do
      instance_double(
        'BlockadeForm',
        validate: false,
        model: Blockade.new,
        errors: form_errors,
      )
    end

    before do
      allow(BlockadeForm).to receive(:new).and_return(failure_case)
    end

    it { is_expected.to_not perform_successfully }

    it 'does not create a blockade' do
      expect { perform }.not_to change(Blockade, :count)
    end

    it 'adds the form errors to the use case' do
      expect(perform.errors[:blocked]).to include 'cannot be yourself'
    end

    it 'adds a base error to the use case' do
      expect(perform.errors[:base]).to include 'Failed to block user'
    end
  end

  describe 'failure to save blockade' do
    before do
      allow_any_instance_of(Blockade).to receive(:save) { false }
    end

    it { is_expected.to_not perform_successfully }

    it 'adds a base error to the use case' do
      expect(perform.errors[:base]).to include 'Failed to block user'
    end
  end
end
