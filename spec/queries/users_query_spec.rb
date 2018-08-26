# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersQuery do
  describe '.all' do
    let(:query_string) { 'tim' }

    let!(:sorted_users) do
      [
        create(:user, first_name: 'tim'),
        create(:user, last_name: 'tim'),
        create(:user, username: 'tim')
      ]
    end

    subject { described_class.all(query_string) }

    before do
      allow(User).to receive(:search_by_names).and_call_original
    end

    it 'passes the query string to the user search scope' do
      expect(User).to receive(:search_by_names).with(query_string)

      subject
    end

    describe 'pagination' do
      subject { described_class.all(query_string, page: { size: 1, number: 2 }) }

      it 'can return a second page' do
        expect(subject).to eq [sorted_users.second]
      end
    end
  end
end
