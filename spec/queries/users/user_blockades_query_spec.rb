# frozen_string_literal: true

require 'rails_helper'

module Users
  RSpec.describe UserBlockadesQuery do
    describe '.all' do
      let!(:user) { create(:user, :with_blocked_users) }

      let(:blockades) { user.blockades }
      let(:sorted_blockades) { blockades.sort_by(&:created_at).reverse }

      subject { described_class.all(user) }

      it 'returns all the user\'s blockades' do
        expect(subject).to match_array blockades
      end

      it 'does not return other user\'s blockades' do
        other_blockades = create_list(:blockade, 2)

        expect(subject).not_to include other_blockades
      end

      describe 'sorting' do
        it 'sorts by created_at attribute' do
          expect(subject).to eq sorted_blockades
        end
      end

      describe 'pagination' do
        subject { described_class.all(user, page: { size: 1, number: 2 }) }

        it 'can return a second page' do
          expect(subject).to eq [sorted_blockades.second]
        end
      end
    end
  end
end
