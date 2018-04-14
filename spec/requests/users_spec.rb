# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST users" do
    before { request_path "/api/v1/users" }

    let(:user_attributes) { attributes_for(:user) }
    let(:params) { post_body("users", user_attributes) }

    subject { do_post params: params }

    it "Success creates a new user" do
      expect { subject }.to change(User, :count).by 1

      expect(response).to have_http_status :created
      expect(response).to match_primary_type "users"
      expect(response).to match_primary_document(email: user_attributes[:email])
      expect(response).to have_top_level_links(self: "/users/me")
    end

    it_behaves_like "request endpoint with data validation"

    it_behaves_like "request with failed action returns unprocessable" do
      before { user_attributes[:email] = "" }

      let(:error_detail) { "Email #{I18n.t(:"errors.not_blank?")}" }
      let(:error_pointer) { "/data/attributes/email" }
    end
  end
end
