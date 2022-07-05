# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CorrectionStyle, type: :model do
  context 'validations' do
    it { should have_many(:correction_style_criterias) }
  end
  context 'scopes' do
    context '.active' do
      it 'returns only the active correction styles' do
        correction_style = create(:correction_style)
        create(:correction_style, active: false)

        expect(CorrectionStyle.active).to eq([correction_style])
      end
    end
  end
end
