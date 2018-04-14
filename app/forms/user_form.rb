# frozen_string_literal: true

require "reform/form/dry"

class UserForm < Reform::Form
  include StripWhitespace

  feature Reform::Form::Dry

  property :email
  property :password

  strip_whitespace :email

  validation :default do
    configure do
      predicates StringPredicates
    end

    required(:email).value(:not_blank?)
    required(:password).value(:not_blank?)
  end

  validation :email_format, if: :default do
    configure do
      predicates EmailPredicates
      option :form

      def unique?(value)
        !User.where.not(id: form.model.id).exists?(email: value)
      end
    end

    required(:email).value(:email_address?)
  end

  validation :email_uniqueness, if: :email_format do
    configure do
      option :form

      def unique?(value)
        !User.where.not(id: form.model.id).exists?(email: value)
      end
    end

    required(:email).value(:unique?)
  end

  validation :password, if: :default do
    required(:password).value(size?: User.password_length)
  end
end
