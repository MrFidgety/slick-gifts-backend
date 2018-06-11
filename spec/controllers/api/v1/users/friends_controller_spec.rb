# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::FriendsController, type: :controller do
  describe 'GET index' do
    let(:user) { build_with_id(:user) }
    let(:friends) { build_list_with_id(:user, 3) }
    let(:id) { user.id }
    let(:params) { default_params.merge(user_id: id) }

    subject { get :index, params: params }

    before do
      authenticate_as(user)
      allow(User).to receive(:find).with(id).and_return(user)
      allow(Users::UserFriendsQuery).to receive(:all)
        .with(user, anything)
        .and_return(friends)
    end

    describe 'Success' do
      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_primary_resources friends }
      it { is_expected.to have_top_level_links(self: "/users/#{id}/friends") }

      it 'uses a query to find the friends' do
        expect(Users::UserFriendsQuery).to receive(:all).with(user, anything)

        subject
      end

      describe 'pagination' do
        before { params[:page] = { number: 2, size: 1 } }

        it 'passes params to query' do
          expected = { page: { number: 2, size: 1 } }

          expect(Users::UserFriendsQuery)
            .to receive(:all).with(anything, hash_including(expected))

          subject
        end
      end
    end

    it_behaves_like 'invalid inclusions returns bad request'
    it_behaves_like 'permits pagination'
    it_behaves_like 'an authenticated endpoint'
    it_behaves_like 'authorization is required'

    it_behaves_like 'non-existent resource returns not found' do
      before do
        allow(User).to receive(:find).with(id)
          .and_raise(ActiveRecord::RecordNotFound)
      end
    end
  end
end
