# frozen_string_literal: true

require 'rspec/expectations'

shared_examples 'a data validation action' do
  include_examples 'missing data key returns bad request'
  include_examples 'invalid data type returns conflict'
end

shared_examples 'invalid inclusions returns bad request' do
  describe 'Bad Request' do
    let(:expected_error) do
      {
        status: '400',
        title: I18n.t(:"renderror.bad_request.title")
      }
    end

    before { params[:include] = 'foobar' }

    it { is_expected.to have_http_status :bad_request }
    it { is_expected.to match_error(expected_error) }
  end
end

shared_examples 'missing data key returns bad request' do
  describe 'Bad Request' do
    let(:expected_error) do
      {
        status: '400',
        title: I18n.t(:"renderror.bad_request.title")
      }
    end

    before { params.delete('data') }

    it { is_expected.to have_http_status :bad_request }
    it { is_expected.to match_error(expected_error) }
  end
end

shared_examples 'permits pagination' do
  describe 'Success' do
    before { params[:page] = { number: 2, size: 1 } }

    it { is_expected.to have_http_status :ok }
  end

  describe 'Bad Request' do
    let(:expected_error) do
      {
        status: '400',
        title: I18n.t(:"renderror.bad_request.title")
      }
    end

    before { params[:page] = 'foobar' }

    it { is_expected.to have_http_status :bad_request }
    it { is_expected.to match_error(expected_error) }
  end
end

shared_examples 'an authenticated endpoint' do
  describe 'Unauthorized' do
    let(:expected_error) do
      {
        status: '401',
        title: I18n.t(:"renderror.unauthorized.title")
      }
    end

    before { authenticate_as(nil) }

    it { is_expected.to have_http_status :unauthorized }
    it { is_expected.to match_error(expected_error) }
  end
end

shared_examples 'authorization is required' do
  describe 'Forbidden' do
    let(:expected_error) do
      {
        status: '403',
        title: I18n.t(:"renderror.forbidden.title")
      }
    end

    before do
      allow_any_instance_of(Ability).to receive(:authorize!)
                                    .and_raise(CanCan::AccessDenied)
    end

    it { is_expected.to have_http_status :forbidden }
    it { is_expected.to match_error(expected_error) }
  end
end

shared_examples 'non-existent resource returns not found' do
  describe 'Not Found' do
    let(:expected_error) do
      {
        status: '404',
        title: I18n.t(:"renderror.not_found.title")
      }
    end

    it { is_expected.to have_http_status :not_found }
    it { is_expected.to match_error(expected_error) }
  end
end

shared_examples 'invalid data type returns conflict' do
  describe 'Conflict' do
    let(:expected_error) do
      {
        status: '409',
        title: I18n.t(:"renderror.conflict.title"),
        detail: I18n.t(:"renderror.conflict.type_mismatch")
      }
    end

    before { params['data']['type'] = 'foobar' }

    it { is_expected.to have_http_status :conflict }
    it { is_expected.to match_error(expected_error) }
  end
end

shared_examples 'resource id mismatch returns conflict' do
  describe 'Conflict' do
    let(:expected_error) do
      {
        status: '409',
        title: I18n.t(:"renderror.conflict.title"),
        detail: I18n.t(:"renderror.conflict.id_mismatch")
      }
    end

    before { params['id'] = 'foobar' }

    it { is_expected.to have_http_status :conflict }
    it { is_expected.to match_error(expected_error) }
  end
end

shared_examples 'an unprocessable action' do |action_klass, action_name|
  let(:error_string) { 'Something went wrong' }

  let(:action_errors) do
    TestErrors.new(error_string)
  end
  let(:failure_case) do
    instance_double('TestUseCase', success?: false, errors: action_errors)
  end

  let(:expected_error) do
    {
      status: '422',
      title: I18n.t(:"renderror.unprocessable_entity.title"),
      detail: error_string
    }
  end

  before do
    allow(action_klass).to receive(action_name).and_return(failure_case)
  end

  it { is_expected.to have_http_status :unprocessable_entity }
  it { is_expected.to match_error expected_error }
end
