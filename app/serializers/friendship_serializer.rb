# frozen_string_literal: true

# == Schema Information
#
# Table name: friendships
#
#  id         :uuid             not null, primary key
#  user_id    :uuid
#  friend_id  :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_friendships_on_friend_id              (friend_id)
#  index_friendships_on_user_id                (user_id)
#  index_friendships_on_user_id_and_friend_id  (user_id,friend_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (friend_id => users.id)
#  fk_rails_...  (user_id => users.id)
#

class FriendshipSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :user
  belongs_to :friend
end
