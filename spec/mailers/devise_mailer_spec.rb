# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviseMailer, type: :mailer do
  describe '#confirmation_instructions' do
    let(:user) { build(:user) }

    let(:mail) do
      described_class.confirmation_instructions(user, 'token').deliver_now
    end

    it 'sets the subject correctly' do
      expect(mail.subject).to eq 'Welcome to Slick Gifts. ' \
                                 'Please confirm your email.'
    end

    it 'sets the to address correctly' do
      expect(mail.to).to eq [user.email]
    end
  end
end
