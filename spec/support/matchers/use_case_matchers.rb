# frozen_string_literal: true

RSpec::Matchers.define :perform_successfully do
  match do |actual|
    actual.perform
    actual.success?
  end

  failure_message do |actual|
    "Expected #{actual}, to be successful, but got errors " +
      actual.errors.details.to_s
  end

  failure_message_when_negated do |actual|
    "Expected #{actual} to not be successful, but got no errors"
  end
end
