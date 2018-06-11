# frozen_string_literal: true

require 'rails_helper'

module Users
  RSpec.describe UserFriendsQuery do
    describe '.all' do
      let!(:user) { create(:user, :with_friends) }

      let(:friends) { user.friends }
      let(:sorted_friends) { friends.sort_by(&:created_at).reverse }

      subject { described_class.all(user) }

      it 'returns all the user\'s friends' do
        expect(subject).to match_array friends
      end

      it 'does not return other user\'s friends' do
        friendships = create_list(:friendship, 2)

        expect(subject).not_to include friendships.map(&:friend)
      end

      describe 'sorting' do
        it 'sorts by created_at attribute' do
          expect(subject).to eq sorted_friends
        end
      end

      describe 'pagination' do
        subject { described_class.all(user, page: { size: 1, number: 2 }) }

        it 'can return a second page' do
          expect(subject).to eq [sorted_friends.second]
        end
      end
    end
  end
end
