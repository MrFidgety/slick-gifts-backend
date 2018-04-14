# frozen_string_literal: true

RSpec.configure do |config|
  def stub_request_host(url)
    allow_any_instance_of(ActionDispatch::Request)
      .to receive(:host) { url }
  end

  TEST_HOST = "example.com".freeze
  config.before(type: :controller) do
    stub_request_host(TEST_HOST)
  end
  config.before(type: :request) do
    stub_request_host(TEST_HOST)
  end
end
