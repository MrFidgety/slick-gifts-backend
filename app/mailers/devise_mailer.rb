# frozen_string_literal: true

class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  helper :application # access to all helpers within `application_helper`.

  default template_path: 'devise/mailer'
  default from: 'noreply@slickgifts.com'

  def confirmation_instructions(record, token, opts = {})
    @resource = record
    @token = token

    mail(to: record.email) do |format|
      format.mjml
    end
  end
end
