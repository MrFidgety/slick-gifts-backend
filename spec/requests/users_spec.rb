# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'POST users' do
    before { request_path '/api/v1/users' }

    let(:user_attributes) { attributes_for(:user) }
    let(:params) { post_body('users', user_attributes) }

    subject { do_post params: params }

    it 'Success creates a new user' do
      expect { subject }.to change(User, :count).by 1

      expect(response).to have_http_status :created
      expect(response).to match_primary_type 'users'
      expect(response).to match_primary_document(email: user_attributes[:email])
    end

    it_behaves_like 'request endpoint with data validation'

    it_behaves_like 'request with failed action returns unprocessable' do
      before { user_attributes[:email] = '' }

      let(:error_detail) { "Email #{I18n.t(:"errors.not_blank?")}" }
      let(:error_pointer) { '/data/attributes/email' }
    end
  end

  describe 'GET users/confirmation' do
    before do
      request_path '/api/v1/users/confirmation?' \
        "confirmation_token=#{user.confirmation_token}"
    end

    let!(:user) { create(:user, :unconfirmed) }

    subject { do_get params: default_params }

    it 'Success confirms a user' do
      expect do
        subject
        user.reload
      end.to change(user, :confirmed?).to true

      expect(response).to have_http_status :ok
      expect(response).to match_primary_type 'sessions'
      expect(response).to render_included_resource user
    end

    it_behaves_like 'request with failed action returns unprocessable' do
      before { user.confirm }

      let(:error_detail) do
        "Email #{I18n.t(:"errors.messages.already_confirmed")}"
      end

      let(:error_pointer) { '/data/attributes/email' }
    end
  end

  describe 'GET /users?search' do
    before { request_path '/api/v1/users' }

    let!(:user) { create(:user, :with_session, :with_friends) }
    let(:headers) { auth_headers_for_user(user) }

    let(:params) do
      { search: 'tim' }
    end

    let!(:matched_users) do
      [
        create(:user, first_name: 'Timothy'),
        create(:user, last_name: 'Timberlake'),
        create(:user, username: 'timbo')
      ]
    end

    subject { do_get params: params, headers: headers }

    it 'Success returns a list of matching users' do
      subject

      expect(response).to have_http_status :ok
      expect(response).to render_primary_resources matched_users
    end

    it_behaves_like 'request permits pagination'
    it_behaves_like 'request requires token authentication'
  end
end
