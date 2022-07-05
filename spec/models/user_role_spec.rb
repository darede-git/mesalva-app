# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserRole, type: :model do
  describe 'Validations' do
    context 'with a valid role' do
      let(:user_role_validation) { build(:user_role_validation) }

      it 'should be valid' do
        expect(user_role_validation).to be_valid
      end
    end
  end
end
