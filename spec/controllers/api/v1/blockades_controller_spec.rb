# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BlockadesController, type: :controller do
  describe 'POST create' do
    before { request_action :create }

    let(:user) { build_with_id(:user) }
    let(:blocked_user) { build_with_id(:user) }

    let(:relationships) do
      { blocked: { type: 'users', id: blocked_user.id } }
    end

    let(:blockade) do
      build_with_id(:blockade, user: user, blocked: blocked_user)
    end

    let(:create_action) do
      instance_double(
        'Blockades::CreateBlockade',
        success?: true,
        blockade: blockade
      )
    end

    let(:expected_attributes) do
      {
        user: { id: user.id },
        blocked: { id: blocked_user.id }
      }
    end

    let(:params) { post_body('blockades', {}, relationships) }

    subject { post :create, params: params }

    before do
      authenticate_as(user)
      allow(Blockades).to receive(:create_blockade)
        .with(expected_attributes)
        .and_return(create_action)
    end

    describe 'Success' do
      it { is_expected.to have_http_status :created }

      it 'creates the blockade' do
        expect(Blockades).to receive(:create_blockade)
          .with(expected_attributes)

        subject
      end

      it 'ignores user id if present in params' do
        relationships[:user] = { type: 'users', id: build_with_id(:user).id }

        expect(Blockades).to receive(:create_blockade)
          .with(expected_attributes)

        subject
      end
    end

    it_behaves_like 'a data validation action'
    it_behaves_like 'an authenticated endpoint'

    it_behaves_like 'non-existent resource returns not found' do
      before do
        allow(Blockades).to receive(:create_blockade)
          .and_raise(ActiveRecord::RecordNotFound)
      end
    end

    it_behaves_like 'an unprocessable action', Blockades, :create_blockade
  end

  describe 'DELETE destroy' do
    before { request_action :destroy }

    let(:user) { build_with_id(:user) }

    let(:blockade) do
      build_with_id(:blockade, user: user)
    end

    let(:destroy_action) do
      instance_double(
        'Blockades::DestroyBlockade',
        success?: true
      )
    end

    let(:params) { default_params.merge(id: blockade.id) }

    subject { delete :destroy, params: params }

    before do
      authenticate_as(user)

      allow(Blockade).to receive(:find)
        .with(blockade.id)
        .and_return(blockade)

      allow(Blockades).to receive(:destroy_blockade)
        .with(blockade)
        .and_return(destroy_action)
    end

    describe 'Success' do
      it { is_expected.to have_http_status :no_content }

      it 'removes the blockade' do
        expect(Blockades).to receive(:destroy_blockade)
          .with(blockade)

        subject
      end
    end

    it_behaves_like 'an authenticated endpoint'
    it_behaves_like 'authorization is required'

    it_behaves_like 'non-existent resource returns not found' do
      before do
        allow(Blockade).to receive(:find)
          .with(blockade.id)
          .and_raise(ActiveRecord::RecordNotFound)
      end
    end

    it_behaves_like 'an unprocessable action',
                    Blockades, :destroy_blockade
  end
end
