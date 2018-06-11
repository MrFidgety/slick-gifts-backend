# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendRequestForm do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }

  let(:form) { described_class.new(FriendRequest.new) }

  let(:friend_request_attributes) do
    {
      user: { id: user.id },
      friend: { id: friend.id }
    }
  end

  subject(:validate) { form.validate(friend_request_attributes) }

  it 'is valid' do
    expect(validate).to eq true
  end

  it 'can create the friend request' do
    expect do
      validate && form.save
    end.to change(FriendRequest, :count).by 1
  end

  it_behaves_like 'reform validates presence of', :user, :friend do
    let(:attributes) { friend_request_attributes }
  end

  it 'validates friend and user are not the same' do
    friend_request_attributes[:friend][:id] = user.id

    expect(validate).to eq false
  end

  it 'validates friend request does not already exist' do
    create(:friend_request, user: user, friend: friend)

    expect(validate).to eq false
  end

  it 'validates friendship does not already exist' do
    create(:friendship, user: user, friend: friend)

    expect(validate).to eq false
  end
end
