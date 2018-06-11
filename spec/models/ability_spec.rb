# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability do
  let(:authable) { create(:user) }
  subject { described_class.new(authable) }

  describe 'user abilities' do
    context 'sessions' do
      it 'can destroy own session' do
        expect(subject)
        .to be_able_to(:destroy, create(:session, authable: authable))
      end

      it 'cannot manage other sessions' do
        expect(subject).not_to be_able_to(
          :create, :read, :update, :destroy, create(:session)
        )
      end
    end

    context 'friend requests' do
      it 'cannot accept friend requests' do
        expect(subject).not_to be_able_to(:accept, create(:friend_request))
      end

      it 'cannot destroy friend requests' do
        expect(subject).not_to be_able_to(:destroy, create(:friend_request))
      end

      context 'as user role' do
        it 'cannot accept friend requests' do
          expect(subject).not_to be_able_to(
            :accept, create(:friend_request, user: authable)
          )
        end

        it 'can destroy friend requests' do
          expect(subject).to be_able_to(
            :destroy, create(:friend_request, user: authable)
          )
        end
      end

      context 'as friend role' do
        it 'can accept friend requests' do
          expect(subject).to be_able_to(
            :accept, create(:friend_request, friend: authable)
          )
        end

        it 'can destroy friend requests' do
          expect(subject).to be_able_to(
            :destroy, create(:friend_request, friend: authable)
          )
        end
      end
    end

    context 'friendships' do
      it 'cannot destroy friendships' do
        expect(subject).not_to be_able_to(:destroy, create(:friendship))
      end

      context 'as user role' do
        it 'can destroy friendships' do
          expect(subject).to be_able_to(
            :destroy, create(:friendship, user: authable)
          )
        end
      end

      context 'as friend role' do
        it 'cannot destroy friendships' do
          expect(subject).not_to be_able_to(
            :destroy, create(:friendship, friend: authable)
          )
        end
      end
    end

    context 'users' do
      it 'cannot list friends' do
        expect(subject).not_to be_able_to(:list_friends, create(:user))
      end

      it 'can list friends own friends' do
        expect(subject).to be_able_to(:list_friends, authable)
      end

      context 'when friends' do
        it 'can list friends' do
          expect(subject).to be_able_to(
            :list_friends, create(:user, friends: [authable])
          )
        end
      end
    end
  end
end
