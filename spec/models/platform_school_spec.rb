# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlatformSchool, type: :model do
  describe 'Validations' do
    context 'with a valid platform school' do
      let(:platform_school) { build(:platform_school) }

      it 'should be valid' do
        expect(platform_school).to be_valid
      end
    end

    context 'without a name' do
      let(:platform_school) { build(:platform_school, name: nil) }

      it 'should be invalid' do
        expect(platform_school).not_to be_valid
      end
    end

    context 'without a city' do
      let(:platform_school) { build(:platform_school, city: nil) }

      it 'should be invalid' do
        expect(platform_school).not_to be_valid
      end
    end
  end
end
