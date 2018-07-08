# frozen_string_literal: true

# == Schema Information
#
# Table name: blockades
#
#  id         :uuid             not null, primary key
#  user_id    :uuid
#  blocked_id :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_blockades_on_blocked_id              (blocked_id)
#  index_blockades_on_user_id                 (user_id)
#  index_blockades_on_user_id_and_blocked_id  (user_id,blocked_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (blocked_id => users.id)
#  fk_rails_...  (user_id => users.id)
#

class BlockadeSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :user
  belongs_to :blocked
end
