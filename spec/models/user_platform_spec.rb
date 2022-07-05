# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPlatform, type: :model do
  describe 'Validations' do
    context 'with a valid platform school' do
      let(:user_platform) { build(:user_platform) }

      it 'should be valid' do
        expect(user_platform).to be_valid
      end
    end

    context 'without a role' do
      let(:user_platform) { build(:user_platform) }

      it 'should save default role' do
        expect(user_platform.role).to eq('student')
      end
    end
  end
end
