# frozen_string_literal: true

require 'reform/form/dry'

class UserForm < Reform::Form
  include StripWhitespace

  feature Reform::Form::Dry

  property :email
  property :password

  strip_whitespace :email

  validation :default do
    configure do
      predicates StringPredicates
      option :form

      def unique?(value)
        !User.where.not(id: form.model.id).exists?(email: value)
      end
    end

    required(:email).value(:not_blank?, :email_address?, :unique?)
    required(:password).value(:not_blank?, size?: User.password_length)
  end
end
