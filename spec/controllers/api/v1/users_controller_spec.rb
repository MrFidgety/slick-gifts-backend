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
    it_behaves_like 'an unprocessable action', Users, :create_user
  end

  describe 'GET index' do
    let(:user) { build_with_id(:user) }
    let(:found_users) { build_list_with_id(:user, 3) }
    let(:params) { default_params.merge(search: 'something') }

    subject { get :index, params: params }

    before do
      authenticate_as(user)
      allow(UsersQuery).to receive(:all)
        .with(params[:search], anything)
        .and_return(found_users)
    end

    describe 'Success' do
      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_primary_resources found_users }

      it 'uses a query to find the users' do
        expect(UsersQuery).to receive(:all).with(params[:search], anything)

        subject
      end

      describe 'pagination' do
        before { params[:page] = { number: 2, size: 1 } }

        it 'passes params to query' do
          expected = { page: { number: 2, size: 1 } }

          expect(UsersQuery)
            .to receive(:all).with(anything, hash_including(expected))

          subject
        end
      end
    end

    it_behaves_like 'permits pagination'
    it_behaves_like 'an authenticated endpoint'
  end
end
