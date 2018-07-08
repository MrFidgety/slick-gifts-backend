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

require 'rails_helper'

RSpec.describe BlockadeSerializer, type: :serializer do
  include_context 'serializer'

  let(:resource) { build(:blockade) }

  describe 'associations' do
    before { resource.save }

    it 'has one user' do
      is_expected.to serialize_has_one(resource.user).with_key('user')
    end

    it 'has one blocked user' do
      is_expected.to serialize_has_one(resource.blocked).with_key('blocked')
    end
  end
end
