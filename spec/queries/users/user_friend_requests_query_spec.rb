# frozen_string_literal: true

require 'rails_helper'

module Users
  RSpec.describe UserFriendRequestsQuery do
    describe '.all' do
      let!(:user) { create(:user, :with_friends) }

      let(:friend_requests) { create_list(:friend_request, 3, user: user) }
      let(:sorted_requests) { friend_requests.sort_by(&:created_at).reverse }

      subject { described_class.all(user) }

      it 'returns all the user\'s friend requests' do
        expect(subject).to match_array friend_requests
      end

      it 'does not return the user\'s pending friend requests' do
        requests = create_list(:friend_request, 2, friend: user)

        expect(subject).not_to include requests
      end

      it 'does not return other user\'s friend requests' do
        requests = create_list(:friend_request, 2)

        expect(subject).not_to include requests
      end

      describe 'sorting' do
        it 'sorts by created_at attribute' do
          expect(subject).to eq sorted_requests
        end
      end

      describe 'pagination' do
        subject { described_class.all(user, page: { size: 1, number: 2 }) }

        it 'can return a second page' do
          expect(subject).to eq [sorted_requests.second]
        end
      end
    end
  end
end
