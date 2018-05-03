# frozen_string_literal: true

RSpec::Matchers.define :be_able_to do |*actions, resource|
  match do |actual|
    actions.all? { |action| actual.can?(action, resource) }
  end

  match_when_negated do |actual|
    actions.none? { |action| actual.can?(action, resource) }
  end

  description do
    "be able to #{actions.join(', ')}: #{resource}"
  end

  failure_message do
    "expected to be able to #{actions.join(', ')}: #{resource}"
  end

  failure_message_when_negated do
    "expected not to be able to #{actions.join(', ')}: #{resource}"
  end
end
