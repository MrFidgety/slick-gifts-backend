# frozen_string_literal: true

RSpec::Matchers.define :serialize_resource do |object|
  match do
    serialized_json(object)["data"] == json(response.body)["data"]
  end

  chain :with do |serializer_klass|
    @serializer_klass = serializer_klass
  end

  failure_message do
    "expected response body #{serialized_json(object)['data']}, " \
    "got #{serialized_json(object)['data']}"
  end

  def serialized_json(object)
    serializer = @serializer_klass.new(object)
    adapted = ActiveModelSerializers::Adapter::JsonApi.new(serializer)
    json(adapted.serializable_hash.to_json)
  end
end

RSpec::Matchers.define :serialize_attributes do |expected|
  match do |actual|
    expected.map do |key|
      actual.keys.include? key
    end.all?
  end
  failure_message do |actual|
    "expected #{actual.keys} to include #{expected}. " \
      "#{actual.keys} is missing #{expected - actual.keys}"
  end
end

RSpec::Matchers.define :serialize_has_one do |expected|
  match do |actual|
    expect(actual.keys).to include @relationship_key
    expect(actual[@relationship_key].dig("id"))
      .to eq expected.id
  end

  chain :with_key do |key|
    @relationship_key = key
  end

  failure_message do |actual|
    "expected #{actual.keys} to include #{@relationship_key} and
    '#{actual_id(actual)}' to equal '#{expected.id}'"
  end

  def actual_id(actual)
    actual[@relationship_key]&.dig("id") || "nil"
  end
end

RSpec::Matchers.define :serialize_has_many do |expected|
  match do |actual|
    expect(actual.keys).to include @relationship_key
    expect(actual[@relationship_key].map_to("id"))
      .to match_array(expected.map(&:id))
  end

  chain :with_key do |key|
    @relationship_key = key
  end

  failure_message do |actual|
    "expected #{actual.keys} to include #{@relationship_key} and
    #{actual_ids(actual)} to match array #{expected.map(&:id)}"
  end

  def actual_ids(actual)
    actual[@relationship_key]&.map_to("id") || []
  end
end
