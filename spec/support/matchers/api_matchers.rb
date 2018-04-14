# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :render_primary_resource do |expected|
  match do |_actual|
    expect(actual_resource[:id]).to eq expected.id
  end

  failure_message do |_actual|
    "expected primary resource with id \"#{expected.id}\", " \
      "got \"#{actual_resource[:id]}\""
  end

  def actual_resource
    @actual_resource ||= deserialize(actual.body)
  end
end

RSpec::Matchers.define :render_primary_resources do |_expected|
  match do |_actual|
    expect(actual_resource_ids).to match_array expected_ids
  end

  failure_message do |_actual|
    "expected primary resources with ids \"#{expected_ids}\", " \
      "got \"#{actual_resource_ids}\""
  end

  def actual_resource_ids
    @actual_resource ||= deserialize_many(actual.body).map_to(:id)
  end

  def expected_ids
    expected.map_to(:id)
  end
end

RSpec::Matchers.define :render_included_resource do |expected|
  match do |_actual|
    expect(included_resource_ids).to include expected.id
  end

  failure_message do |_actual|
    "expected include resource with id \"#{expected.id}\", " \
      " got ids \"#{included_resource_ids || []}\""
  end

  def included_resource_ids
    @actual_resource ||= deserialize_included(actual.body)&.map_to(:id)
  end
end

RSpec::Matchers.define :match_primary_document do |expected|
  match do |_actual|
    expected.each do |(key, value)|
      expect(actual_resource[key]).to eq value
    end
  end

  failure_message do |_actual|
    "expected primary document '#{expected.inspect}', " \
      "got #{actual_resource.inspect}"
  end

  def actual_resource
    @actual_resource ||= deserialize(actual.body)
  end
end

RSpec::Matchers.define :match_primary_documents do |expected|
  match do |_actual|
    expect(actual_sliced).to match_array expected
  end

  failure_message do |_actual|
    "expected primary documents '#{expected.inspect}', " \
      "got #{actual_sliced.inspect}"
  end

  def actual_sliced
    deserialize_many(actual.body).map do |resource|
      resource.slice(*expected.first.keys)
    end
  end
end

RSpec::Matchers.define :match_error do |expected|
  match do |_actual|
    expect(actual_errors).not_to be_empty

    expected.deep_stringify_keys!

    expect(actual_errors.select do |error|
      error.slice(*expected.keys.map(&:to_s)) == expected
    end).not_to be_empty
  end

  failure_message do |_actual|
    "expected error \"#{expected}\", got errors #{actual_errors}"
  end

  def actual_errors
    deserialize_errors(actual.body)
  end
end

RSpec::Matchers.define :match_error_title do |expected|
  match do |_actual|
    expect(actual_errors).not_to be_empty

    expect(actual_titles.select { |s| s == expected }).not_to be_empty
  end

  failure_message do |_actual|
    "expected error with title \"#{expected}\", got errors #{actual_titles}"
  end

  def actual_errors
    deserialize_errors(actual.body)
  end

  def actual_titles
    actual_errors.map_to("title")
  end
end

RSpec::Matchers.define :match_primary_type do |expected|
  match do |_actual|
    expect(actual_type).to eq expected
  end

  failure_message do |_actual|
    "expected primary type '#{expected}', got '#{actual_type}'"
  end

  def actual_resource
    @actual_resource ||= deserialize(actual.body)
  end

  def actual_type
    json(actual.body).dig(:data, :type)
  end
end

RSpec::Matchers.define :have_top_level_links do |expected|
  match do |actual|
    expected.map do |(key, expected_link)|
      links_key_present?(actual) &&
        (actual_url_for_key(actual, key) == expected_url(expected_link))
    end.all?
  end

  failure_message do |actual|
    if links_key_present?(actual)
      "expected links '#{expected}' but got links " \
      "#{json(actual.body)['links']}'"
    else
      "expected root level key 'links', but got keys " \
      "#{json(actual.body).keys}"
    end
  end

  def expected_url(path)
    "http://example.com/api/v1#{path}"
  end

  def links_key_present?(actual)
    json(actual.body).keys.include? "links"
  end

  def actual_url_for_key(actual, key)
    json(actual.body).dig("links", key.to_s)&.split("?")&.first
  end
end
