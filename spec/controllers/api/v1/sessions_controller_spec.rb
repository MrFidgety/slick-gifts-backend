# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST create' do
    let(:session_attributes) do
      {
        access_type: 'password',
        passkey: user.email,
        passcode: user.password
      }
    end
    let(:action_success) do
      instance_double(
        'Sessions::CreateSession',
        success?: true,
        session: session
      )
    end

    let(:params) { post_body('sessions', session_attributes) }
    let(:session) { build_with_id(:session) }
    let(:user) { build_with_id(:user) }

    subject { post :create, params: params }

    before do
      allow(Sessions).to receive(:create_session).and_return(action_success)
      allow(session).to receive(:authable).and_return(user)
    end

    describe 'Success' do
      it { is_expected.to have_http_status :created }
      it { is_expected.to render_primary_resource session }
      it { is_expected.to render_included_resource user }

      it 'creates a session' do
        expect(Sessions).to receive(:create_session)
          .with(session_attributes.slice(:access_type, :passkey, :passcode))
          .and_return(action_success)

        subject
      end

      it 'dismisses invalid attribute keys' do
        session_attributes[:invalid_key] = 'value'

        expect(Sessions).to receive(:create_session)
          .with(session_attributes.slice(:access_type, :passkey, :passcode))

        subject
      end
    end

    it_behaves_like 'a data validation action'
    it_behaves_like 'an unprocessable action', Sessions, :create_session
  end

  describe 'DELETE destroy' do
    let(:user) { build_with_id(:user) }
    let(:session) { build_with_id(:session, authable: user) }
    let(:params) { default_params.merge(id: session.id) }

    subject { delete :destroy, params: params }

    before do
      authenticate_as(user)
      allow(DeviseSessionable::Session).to receive(:find)
        .with(session.id)
        .and_return(session)
    end

    describe 'Success' do
      it { is_expected.to have_http_status :no_content }

      it 'calls destroy on session' do
        expect(session).to receive(:destroy) { true }

        subject
      end
    end

    it_behaves_like 'an authenticated endpoint'
    it_behaves_like 'authorization is required'

    it_behaves_like 'non-existent resource returns not found' do
      before do
        allow(DeviseSessionable::Session)
          .to receive(:find)
          .and_raise(ActiveRecord::RecordNotFound)
      end
    end
  end
end
