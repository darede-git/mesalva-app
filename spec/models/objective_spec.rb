# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Objective, type: :model do
  context 'validations' do
    should_be_present(:name)
    it { should validate_uniqueness_of :name }
  end

  context 'scopes' do
    context '.active' do
      let!(:active) { create(:objective) }
      let!(:inactive) { create(:objective, :inactive) }

      it 'returns only the active objectives' do
        expect(Objective.active).to eq([active])
      end
    end
  end
end
