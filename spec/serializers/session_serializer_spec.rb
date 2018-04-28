# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionSerializer, type: :serializer do
  include_context 'serializer'

  let(:resource) { build(:session) }

  describe 'attributes' do
    let(:attributes) do
      %w[id authentication_token]
    end

    it { is_expected.to serialize_attributes(attributes) }
  end

  describe 'associations' do
    it do
      user = create(:user, sessions: [resource])
      is_expected.to serialize_has_one(user).with_key('authable')
    end
  end
end
