# frozen_string_literal: true

require "rspec/expectations"

shared_examples "request endpoint with data validation" do
  include_examples "request with missing data key returns bad request"
  include_examples "request with invalid data type returns conflict"
end

shared_examples "request with missing data key returns bad request" do
  it "Bad Request" do
    params.delete("data")
    subject

    expected_error = {
      status: "400",
      title: I18n.t(:"renderror.bad_request.title")
    }

    expect(response).to have_http_status :bad_request
    expect(response).to match_error(expected_error)
  end
end

shared_examples "request with invalid data type returns conflict" do
  it "Conflict" do
    params["data"]["type"] = "foobar"
    subject

    expected_error = {
      status: "409",
      title: I18n.t(:"renderror.conflict.title"),
      detail: I18n.t(:"renderror.conflict.type_mismatch")
    }

    expect(response).to have_http_status :conflict
    expect(response).to match_error(expected_error)
  end
end

shared_examples "request with failed action returns unprocessable" do |detail,
   pointer|

  let!(:expected_error) do
    {
      status: "422",
      title: I18n.t(:"renderror.unprocessable_entity.title"),
      detail:  error_detail,
      source: {
        pointer: error_pointer
      }
    }
  end

  it "Unprocessable Entity" do
    subject

    expect(response).to have_http_status :unprocessable_entity
    expect(response).to match_error(expected_error)
  end
end
