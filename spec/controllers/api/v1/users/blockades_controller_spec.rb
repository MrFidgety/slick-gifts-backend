# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::BlockadesController, type: :controller do
  describe 'GET index' do
    let(:user) { build_with_id(:user) }
    let(:blockades) { build_list_with_id(:blockade, 3) }
    let(:id) { user.id }
    let(:params) { default_params.merge(user_id: id) }

    subject { get :index, params: params }

    before do
      authenticate_as(user)
      allow(User).to receive(:find).with(id).and_return(user)
      allow(Users::UserBlockadesQuery).to receive(:all)
        .with(user, anything)
        .and_return(blockades)
    end

    describe 'Success' do
      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_primary_resources blockades }
      it { is_expected.to have_top_level_links(self: "/users/#{id}/blockades") }

      it 'uses a query to find the blockades' do
        expect(Users::UserBlockadesQuery).to receive(:all).with(user, anything)

        subject
      end

      describe 'pagination' do
        before { params[:page] = { number: 2, size: 1 } }

        it 'passes params to query' do
          expected = { page: { number: 2, size: 1 } }

          expect(Users::UserBlockadesQuery)
            .to receive(:all).with(anything, hash_including(expected))

          subject
        end
      end

      describe 'resource inclusion' do
        let(:inclusions) { %i[blocked] }

        let(:related) do
          inclusions.each_with_object({}) do |inc, memo|
            memo[inc] = blockades.map(&inc)
          end
        end

        before do
          params[:include] = inclusions.join(',').dasherize
        end

        it 'passes params to query' do
          expected = { includes: %w[blocked] }

          expect(Users::UserBlockadesQuery)
            .to receive(:all).with(anything, hash_including(expected))

          subject
        end

        it { is_expected.to render_included_resources related.values.flatten }
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
