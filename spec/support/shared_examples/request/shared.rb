# frozen_string_literal: true

require 'rspec/expectations'

shared_examples 'request endpoint with data validation' do
  include_examples 'request with missing data key returns bad request'
  include_examples 'request with invalid data type returns conflict'
end

shared_examples 'request with missing data key returns bad request' do
  describe 'Bad Request' do
    let(:expected_error) do
      {
        status: '400',
        title: I18n.t(:"renderror.bad_request.title")
      }
    end

    before { params.delete('data') }

    it 'when missing data key' do
      subject

      expect(response).to have_http_status :bad_request
      expect(response).to match_error(expected_error)
    end
  end
end

shared_examples 'request with invalid inclusions returns bad request' do
  describe 'Bad Request' do
    let(:expected_error) do
      {
        status: '400',
        title: I18n.t(:"renderror.bad_request.title")
      }
    end

    before { params[:include] = 'foobar' }

    it 'with invalid include query params' do
      subject

      expect(response).to have_http_status :bad_request
      expect(response).to match_error(expected_error)
    end
  end
end

shared_examples 'request permits pagination' do
  it 'permits pagination params' do
    params[:page] = { number: 2, size: 1 }
    subject

    expect(response).to have_http_status :ok
  end

  describe 'Bad Request' do
    let(:expected_error) do
      {
        status: '400',
        title: I18n.t(:"renderror.bad_request.title")
      }
    end

    it 'with invalid pagination query params' do
      params[:page] = { foo: 'bar' }
      subject

      expect(response).to have_http_status :bad_request
      expect(response).to match_error(expected_error)
    end
  end
end

shared_examples 'request requires token authentication' do
  describe 'Unauthorized' do
    let(:expected_error) do
      {
        status: '401',
        title: I18n.t(:"renderror.unauthorized.title")
      }
    end

    before { headers['X-Session-Token'] = nil }

    it 'without token authentication' do
      subject

      expect(response).to have_http_status :unauthorized
      expect(response).to match_error(expected_error)
    end
  end
end

shared_examples 'request requires authorization' do
  describe 'Forbidden' do
    let(:expected_error) do
      {
        status: '403',
        title: I18n.t(:"renderror.forbidden.title")
      }
    end

    let(:unauthorized_user) { create(:user, :with_session) }
    let(:headers) { auth_headers_for_user unauthorized_user }

    it 'without permission' do
      subject

      expect(response).to have_http_status :forbidden
      expect(response).to match_error(expected_error)
    end
  end
end

shared_examples 'request with non-existent resource returns not found' do
  describe 'Not Found' do
    let(:expected_error) do
      {
        status: '404',
        title: I18n.t(:"renderror.not_found.title")
      }
    end

    it 'when finding resource raises an error' do
      subject

      expect(response).to have_http_status :not_found
      expect(response).to match_error(expected_error)
    end
  end
end

shared_examples 'request with invalid data type returns conflict' do
  describe 'Conflict' do
    let(:expected_error) do
      {
        status: '409',
        title: I18n.t(:"renderror.conflict.title"),
        detail: I18n.t(:"renderror.conflict.type_mismatch")
      }
    end

    before { params['data']['type'] = 'foobar' }

    it 'when resource type is invalid' do
      subject

      expect(response).to have_http_status :conflict
      expect(response).to match_error(expected_error)
    end
  end
end

shared_examples 'request with failed action returns unprocessable' do
  describe 'Unprocessable Entity' do
    let!(:expected_error) do
      {
        status: '422',
        title: I18n.t(:"renderror.unprocessable_entity.title"),
        detail:  error_detail,
        source: {
          pointer: error_pointer
        }
      }
    end

    it 'when action fails' do
      subject

      expect(response).to have_http_status :unprocessable_entity
      expect(response).to match_error(expected_error)
    end
  end
end
