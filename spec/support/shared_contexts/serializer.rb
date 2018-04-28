# frozen_string_literal: true

require 'rspec/expectations'

shared_context 'serializer' do
  let(:resource) { nil }
  let(:serializer) { described_class.new(resource) }

  subject do
    JSON.parse(serializer.to_json)
  end
end
