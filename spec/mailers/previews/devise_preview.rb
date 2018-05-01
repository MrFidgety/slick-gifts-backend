# frozen_string_literal: true

class DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    user = FactoryBot.build(:user, :unconfirmed)

    DeviseMailer.confirmation_instructions(user, 'thetoken', {})
  end
end
