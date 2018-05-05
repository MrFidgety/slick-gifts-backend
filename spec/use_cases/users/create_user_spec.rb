# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::CreateUser do
  let(:user_attributes) { attributes_for(:user) }

  subject { described_class.new(user_attributes) }

  let(:perform) { subject.tap(&:perform) }

  describe 'Success' do
    it { is_expected.to perform_successfully }

    it 'creates a user' do
      expect { perform }.to change(User, :count).by 1
    end

    it 'schedules a confirmation email' do
      Sidekiq::Testing.inline! do
        expect { perform }.to change(Devise::Mailer.deliveries, :count).by 1
      end
    end

    describe 'unconfirmed user already exists' do
      let!(:user) do
        create(:user, :unconfirmed, email: user_attributes[:email])
      end

      it 'does not create a user' do
        expect { perform }.not_to change(User, :count)
      end

      it 'updates the password' do
        expect do
          perform
          user.reload
        end.to change(user, :encrypted_password)
      end

      it 'resends the confirmation email if it was last sent >1min' do
        user.update(confirmation_sent_at: 2.minutes.ago)

        Sidekiq::Testing.inline! do
          expect { perform }.to change(Devise::Mailer.deliveries, :count).by 1
        end
      end

      it 'does not resend the confirmation email if it was last sent <1min' do
        user.update(confirmation_sent_at: 50.seconds.ago)

        Sidekiq::Testing.inline! do
          expect { perform }.not_to change(Devise::Mailer.deliveries, :count)
        end
      end
    end
  end

  describe 'confirmed user already exists' do
    let!(:user) { create(:user, user_attributes) }

    it { is_expected.not_to perform_successfully }

    it 'does not create a user' do
      expect { perform }.not_to change(User, :count)
    end

    it 'adds form errors to the use case' do
      expect(perform.errors.messages).not_to be_empty
    end
  end

  describe 'invalid attributes' do
    let(:form_errors) do
      Reform::Contract::Errors.new.tap do |e|
        e.add(:email, I18n.t(:'errors.not_blank?'))
        e.add(:email, I18n.t(:'errors.email_address?'))
      end
    end

    before { user_attributes.delete(:email) }

    it { is_expected.not_to perform_successfully }

    it 'does not create a user' do
      expect { perform }.not_to change(User, :count)
    end

    it 'adds the first of each form error to the use case' do
      actual = perform.errors.messages[:email]
      expected = [form_errors.messages[:email].first]

      expect(actual).to eq expected
    end
  end

  describe 'failure to save user' do
    before do
      allow_any_instance_of(UserForm).to receive(:save) { false }
    end

    it { is_expected.to_not perform_successfully }

    it 'adds a base error to the use case' do
      expect(perform.errors[:base]).to include 'Failed to save user'
    end
  end
end
