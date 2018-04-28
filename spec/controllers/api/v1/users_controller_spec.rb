# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'POST create' do
    before { request_action :create }

    let(:user_attributes) { attributes_for(:user) }
    let(:params) { post_body('users', user_attributes) }
    let(:user) { build_with_id(:user, user_attributes) }

    let(:success_case) do
      instance_double(
        'Users::CreateUser',
        success?: true,
        user: user
      )
    end

    subject { do_post params: params }

    before { allow(Users).to receive(:create_user).and_return(success_case) }

    describe 'Success' do
      it { is_expected.to have_http_status :created }
      it { is_expected.to render_primary_resource user }

      it 'creates the user' do
        expect(Users).to receive(:create_user)
                            .with(user_attributes)
                            .and_return(success_case)

        subject
      end
    end

    it_behaves_like 'a data validation action'
    it_behaves_like 'unprocessable action', Users, :create_user
  end
end
