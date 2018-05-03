# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sessions::CreateSession do
  let!(:user) { create(:user) }

  let(:session_attributes) do
    {
      access_type: 'password',
      passkey: user.email,
      passcode: user.password
    }
  end

  subject { described_class.new(session_attributes) }

  let(:perform) { subject.tap(&:perform) }

  describe 'Success' do
    it { is_expected.to perform_successfully }

    it 'creates a session' do
      expect { perform }.to change(DeviseSessionable::Session, :count).by 1
    end

    it 'creates a session for the correct user' do
      expect { perform }.to change(user.sessions, :count).by 1
    end

    it 'exposes the session' do
      expect(perform.session).to be_a DeviseSessionable::Session
    end
  end

  describe 'invalid credentials' do
    let(:expected_error) do
      { base: [I18n.t(:"devise.auth.password.failure")] }
    end

    context 'invalid password' do
      before { session_attributes[:passcode] = 'invalid' }

      it { is_expected.to_not perform_successfully }

      it 'does not create a session' do
        expect { perform }.not_to change(DeviseSessionable::Session, :count)
      end

      it 'adds errors to the use case' do
        expect(perform.errors.messages).to include expected_error
      end
    end

    context 'missing email' do
      before { session_attributes.delete(:passkey) }

      it { is_expected.to_not perform_successfully }

      it 'does not create a session' do
        expect { perform }.not_to change(DeviseSessionable::Session, :count)
      end

      it 'adds errors to the use case' do
        expect(perform.errors.messages).to include expected_error
      end
    end

    context 'missing password' do
      before { session_attributes.delete(:passcode) }

      it { is_expected.to_not perform_successfully }

      it 'does not create a session' do
        expect { perform }.not_to change(DeviseSessionable::Session, :count)
      end

      it 'adds errors to the use case' do
        expect(perform.errors.messages).to include expected_error
      end
    end
  end

  describe 'invalid access type' do
    let(:expected_error) do
      { base: [I18n.t(:"devise.auth.invalid_type")] }
    end

    before { session_attributes[:access_type] = 'invalid' }

    it { is_expected.to_not perform_successfully }

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

    it { is_expected.to_not perform_successfully }

    it 'adds a base error to the use case' do
      expect(perform.errors[:base]).to include 'Failed to create session'
    end
  end
end
