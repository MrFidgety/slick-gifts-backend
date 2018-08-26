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

require 'rails_helper'

RSpec.describe User, type: :model do
  it_behaves_like 'has a valid factory'

  it { is_expected.to have_many(:friend_requests).dependent(:destroy) }
  it { is_expected.to have_many(:pending_friends).through(:friend_requests) }
  it { is_expected.to have_many(:friendships).dependent(:destroy) }
  it { is_expected.to have_many(:friends).through(:friendships) }
  it { is_expected.to have_many(:blockades).dependent(:destroy) }
  it { is_expected.to have_many(:blocked_users).through(:blockades) }

  describe '.search_by_names' do
    let!(:first_name_match) { create(:user, first_name: 'tim') }
    let!(:last_name_match) { create(:user, last_name: 'tim') }
    let!(:username_match) { create(:user, username: 'tim') }
    let!(:other_user) { create(:user, first_name: 'smith') }

    subject { described_class.search_by_names('tim') }

    it 'returns users with matching start of first name' do
      expect(subject).to include first_name_match
    end

    it 'returns users with matching start of last name' do
      expect(subject).to include last_name_match
    end

    it 'returns users with matching start of username' do
      expect(subject).to include username_match
    end

    it 'ranks using first, last, then username' do
      sorted_users = [
        first_name_match,
        last_name_match,
        username_match,
      ]

      expect(subject).to eq sorted_users
    end

    it 'matches on any word from the query' do
      expect(described_class.search_by_names('tim smith')).to include other_user
    end
  end
end
