# frozen_string_literal: true

require 'rails_helper'

module Users
  RSpec.describe Users::PublicUserSerializer, type: :serializer do
    include_context 'serializer'

    let(:resource) { build(:user) }
    let(:attributes) { %w[id first_name last_name username] }

    it { is_expected.to serialize_attributes(attributes) }
  end
end
