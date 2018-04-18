# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::CreateUser do
  let(:user_attributes) { attributes_for(:user) }

  subject { described_class.new(user_attributes) }

  let(:perform) { subject.tap(&:perform) }

  describe "Success" do
    it { is_expected.to perform_successfully }

    it "creates a user" do
      expect { perform }.to change(User, :count).by 1
    end

    it "schedules a confirmation email" do
      Sidekiq::Testing.inline! do
        expect { perform }.to change(Devise::Mailer.deliveries, :count).by 1
      end
    end
  end

  describe "invalid attributes" do
    let(:form_errors) do
      Reform::Contract::Errors.new.tap do |e|
        e.add(:email, "must be filled")
      end
    end

    let(:failure_case) do
      instance_double(
        "UserForm", validate: false, model: nil, errors: form_errors
      )
    end

    before do
      allow(UserForm).to receive(:new).and_return(failure_case)
    end

    it { is_expected.not_to perform_successfully }

    it "does not create a user" do
      expect { perform }.not_to change(User, :count)
    end

    it "adds form errors to the use case" do
      expect(perform.errors.messages).to include form_errors.messages
    end
  end

  describe "failure to save user" do
    before do
      allow_any_instance_of(UserForm).to receive(:save) { false }
    end

    it { is_expected.to_not perform_successfully }

    it "adds a base error to the use case" do
      expect(perform.errors[:base]).to include "Failed to save user"
    end
  end
end
