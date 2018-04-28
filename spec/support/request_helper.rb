# frozen_string_literal: true

RSpec.configure do |c|
  def default_params
    { format: :json }
  end

  def request_path(path)
    @path = path
  end

  def request_action(action)
    request_path(action)
  end

  %w[get post patch delete].each do |verb|
    define_method("do_#{verb}".to_sym) do |options = {}|
      do_request(verb.to_sym, options)
    end
  end

  def do_request(request_type, options = {})
    public_send(request_type, @path, options)
  end

  c.before(:example, type: :request) do
    @path = nil
  end

  def post_body(type_string, attributes, relationships = {})
    default_params.merge(
      'data' => request_body_data(type_string, attributes, relationships)
    )
  end

  def request_body_data(type_string, attributes, relationships)
    {
      'type' => type_string,
      'attributes' => serialize_request_attributes(attributes)
    }.merge(request_body_relationships(relationships))
  end

  def request_body_relationships(relationships)
    return {} unless relationships.any?

    { 'relationships' => serialize_request_relationships(relationships) }
  end

  def serialize_request_attributes(attributes)
    return multi_resource_attributes(attributes) if attributes.is_a? Array

    resource_attributes(attributes)
  end

  def serialize_request_relationships(relationships)
    relationships.reduce({}) do |acc, (k, v)|
      acc.merge(
        k.to_s.dasherize => { 'data' => serialize_request_attributes(v) }
      )
    end
  end

  def resource_attributes(attributes)
    attributes.reduce({}) do |acc, (k, v)|
      acc.merge(k.to_s.dasherize => v)
    end
  end

  def multi_resource_attributes(attributes_array)
    attributes_array.map do |attributes|
      resource_attributes(attributes)
    end
  end
end
