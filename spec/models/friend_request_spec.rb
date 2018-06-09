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

RSpec.describe FriendRequest, type: :model do
  it_behaves_like 'has a valid factory' do
    before do
      attributes.merge!(
        user: { id: create(:user).id },
        friend: { id: create(:user).id }
      )
    end
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:friend) }
end
