# frozen_string_literal: true

# == Schema Information
#
# Table name: friend_requests
#
#  id         :uuid             not null, primary key
#  user_id    :uuid
#  friend_id  :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_friend_requests_on_friend_id  (friend_id)
#  index_friend_requests_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (friend_id => users.id)
#  fk_rails_...  (user_id => users.id)
#


require 'rails_helper'

RSpec.describe FriendRequestSerializer, type: :serializer do
  include_context 'serializer'

  let(:resource) { build(:friend_request) }

  describe 'associations' do
    before { resource.save }

    it 'has one user' do
      is_expected.to serialize_has_one(resource.user).with_key('user')
    end

    it 'has one friend' do
      is_expected.to serialize_has_one(resource.friend).with_key('friend')
    end
  end
end
