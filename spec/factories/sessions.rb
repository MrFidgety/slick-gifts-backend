# frozen_string_literal: true

FactoryBot.define do
  factory :session, class: DeviseSessionable::Session do
    association :authable, factory: :user
  end
end
