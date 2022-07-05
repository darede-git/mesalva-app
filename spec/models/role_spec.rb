# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'Validations' do
    context 'with a valid role' do
      let(:role) { build(:role) }

      it 'should be valid' do
        expect(role).to be_valid
      end
    end
  end
end
