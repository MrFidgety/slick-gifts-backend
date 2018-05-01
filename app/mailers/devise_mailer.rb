# frozen_string_literal: true

class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  helper :application # access to all helpers within `application_helper`.

  default template_path: 'devise/mailer'
  default from: 'noreply@slick.gifts'

  def confirmation_instructions(record, token, opts = {})
    @resource = record
    @token = token
    @frontend_url = Rails.application.config.frontend_url
    @confirmation_url = "#{@frontend_url}/confirm?token=#{token}"

    mail(to: record.email) { |format| format.mjml }
  end
end
