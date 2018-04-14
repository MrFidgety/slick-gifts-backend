# frozen_string_literal: true

module StringPredicates
  include Dry::Logic::Predicates

  predicate(:not_blank?) { |value| value.present? }
end
