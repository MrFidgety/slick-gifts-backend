# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :citext
#  last_name              :citext
#  username               :citext
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

FactoryBot.define do
  factory :user, aliases: [:friend, :blocked] do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.unique.user_name }

    transient do
      confirmed true
    end

    trait :unconfirmed do
      confirmed false
    end

    trait :with_session do
      after :create do |user|
        create(:session, authable: user)
      end
    end

    trait :with_friends do
      after :create do |user|
        create_list(:friendship, 5, user: user)
      end
    end

    trait :with_blocked_users do
      after :create do |user|
        create_list(:blockade, 5, user: user)
      end
    end

    after(:build) do |user, evaluator|
      if evaluator.confirmed
        # Set user to be confirmed by default
        user.skip_confirmation!
      else
        # Set user to be unconfirmed without sending email
        user.skip_confirmation_notification!
      end
    end
  end
end
