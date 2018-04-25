# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::Users::ConfirmationsController, type: :controller do
  describe "GET show" do
    before { request_action :show }

    let(:user) { create(:user, :unconfirmed) }
    let(:session) { build_with_id(:session, authable: user) }
    let(:attributes) { { confirmation_token: user.confirmation_token } }
    let(:params) { default_params.merge(attributes) }

    let(:success_case) do
      instance_double(
        "Users::ConfirmUser",
        success?: true,
        session: session
      )
    end

    subject { do_get params: params }

    before { allow(Users).to receive(:confirm_user).and_return(success_case) }

    describe "Success" do
      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_primary_resource session }
      it { is_expected.to render_included_resource user }

      it "confirms the user" do
        expect(Users).to receive(:confirm_user)
                            .with(attributes)
                            .and_return(success_case)

        subject
      end
    end

    it_behaves_like "unprocessable action", Users, :confirm_user
  end
end
