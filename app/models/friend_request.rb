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
#  index_friend_requests_on_friend_id              (friend_id)
#  index_friend_requests_on_user_id                (user_id)
#  index_friend_requests_on_user_id_and_friend_id  (user_id,friend_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (friend_id => users.id)
#  fk_rails_...  (user_id => users.id)
#

class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: User.name

  def accept
    user.friends << friend
    destroy
  end
end
