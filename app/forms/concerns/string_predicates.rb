# frozen_string_literal: true

module StringPredicates
  include Dry::Logic::Predicates

  predicate(:not_blank?) { |value| value.present? }
  predicate(:email_address?) { |value| Devise.email_regexp.match? value }
end
