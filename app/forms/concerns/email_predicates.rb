# frozen_string_literal: true

module EmailPredicates
  include Dry::Logic::Predicates

  predicate(:email_address?) { |value| Devise.email_regexp.match? value }
end
