# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendSerializer, type: :serializer do
  include_context 'serializer'

  let(:resource) { build(:user) }
  let(:attributes) { %w[id] }

  it { is_expected.to serialize_attributes(attributes) }
end
