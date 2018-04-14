# frozen_string_literal: true

RSpec.configure do
  def deserialize(response)
    ActiveModelSerializers::Deserialization.jsonapi_parse!(
      json(response)
    )
  end

  def deserialize_many(response)
    json(response).fetch("data").map do |resource|
      ActiveModelSerializers::Deserialization.jsonapi_parse!(
        "data" => resource
      )
    end
  end

  def deserialize_included(response)
    json(response)["included"]&.map do |included|
      data = { "data" => included }
      ActiveModelSerializers::Deserialization.jsonapi_parse!(data)
    end
  end

  def deserialize_errors(response)
    json(response)["errors"]&.map(&:with_indifferent_access)
  end

  def json(response)
    JSON.parse(response).with_indifferent_access
  end
end
