# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::ConfirmUser do
  let!(:user) { create(:user, :unconfirmed) }
  let(:attributes) { { confirmation_token: user.confirmation_token } }

  subject { described_class.new(attributes) }

  let(:perform) { subject.tap(&:perform) }

  describe 'Success' do
    it { is_expected.to perform_successfully }

    it 'confirms the user' do
      expect do
        perform
        user.reload
      end.to change(user, :confirmed?).to true
    end

    it 'creates a session for the user' do
      expect { perform }.to change(user.sessions, :count).by 1
    end

    it 'exposes the session' do
      expect(perform.session).to be_a DeviseSessionable::Session
    end
  end

  describe 'invalid confirmation token' do
    let(:expected_error) do
      { confirmation_token: [I18n.t(:"errors.messages.invalid")] }
    end

    before { attributes[:confirmation_token] = 'invalid' }

    it { is_expected.not_to perform_successfully }

    it 'does not confirm the user' do
      expect do
        perform
        user.reload
      end.not_to change(user, :confirmed?)
    end

    it 'does not create a session' do
      expect { perform }.not_to change(DeviseSessionable::Session, :count)
    end

    it 'adds errors to the use case' do
      expect(perform.errors.messages).to include expected_error
    end
  end

  describe 'expired confirmation token' do
    let(:expected_error) do
      {
        email: [
          I18n.t(:"errors.messages.confirmation_period_expired",
            period: "#{Devise.confirm_within.parts[:days]} days"
          )
        ]
      }
    end

    before { user.update(confirmation_sent_at: Devise.confirm_within.ago) }

    it { is_expected.not_to perform_successfully }

    it 'does not confirm the user' do
      expect do
        perform
        user.reload
      end.not_to change(user, :confirmed?)
    end

    it 'does not create a session' do
      expect { perform }.not_to change(DeviseSessionable::Session, :count)
    end

    it 'adds errors to the use case' do
      expect(perform.errors.messages).to include expected_error
    end
  end

  describe 'user already confirmed' do
    let(:expected_error) do
      { email: [I18n.t(:"errors.messages.already_confirmed")] }
    end

    before do
      User.confirm_by_token(attributes[:confirmation_token])
      user.reload
    end

    it { is_expected.not_to perform_successfully }

    it 'does not change the user confirmed status' do
      expect do
        perform
        user.reload
      end.not_to change(user, :confirmed?)
    end

    it 'does not create a session' do
      expect { perform }.not_to change(DeviseSessionable::Session, :count)
    end

    it 'adds errors to the use case' do
      expect(perform.errors.messages).to include expected_error
    end
  end

  describe 'failure to create session' do
    before do
      allow(DeviseSessionable::Session).to receive(:create).and_return(false)
    end

    it { is_expected.not_to perform_successfully }

    it 'does not confirm the user' do
      expect do
        perform
        user.reload
      end.not_to change(user, :confirmed?)
    end

    it 'adds a base error to the use case' do
      expect(perform.errors[:base]).to include 'Failed to create session'
    end
  end
end
