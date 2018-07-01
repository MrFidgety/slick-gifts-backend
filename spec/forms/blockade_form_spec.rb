# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlockadeForm do
  let(:user) { create(:user) }
  let(:blocked_user) { create(:user) }

  let(:form) { described_class.new(Blockade.new) }

  let(:blockade_attributes) do
    {
      user: { id: user.id },
      blocked: { id: blocked_user.id }
    }
  end

  subject(:validate) { form.validate(blockade_attributes) }

  it 'is valid' do
    expect(validate).to eq true
  end

  it 'can create the blockade' do
    expect do
      validate && form.save
    end.to change(Blockade, :count).by 1
  end

  it_behaves_like 'reform validates presence of', :user, :blocked do
    let(:attributes) { blockade_attributes }
  end

  it 'validates blocked and user are not the same' do
    blockade_attributes[:blocked][:id] = user.id

    expect(validate).to eq false
  end

  it 'validates blockade does not already exist' do
    create(:blockade, user: user, blocked: blocked_user)

    expect(validate).to eq false
  end
end
