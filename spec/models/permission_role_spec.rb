# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PermissionRole, type: :model do
  describe 'Validations' do
    context 'with a valid permission role' do
      let(:permission_role) { build(:permission_role_validation) }

      it 'should be valid' do
        expect(permission_role).to be_valid
      end
    end

    context 'without role' do
      let(:permission_role) { build(:permission_role_without_role) }

      it 'should be invalid' do
        expect(permission_role).not_to be_valid
      end
    end

    context 'without permission' do
      let(:permission_role) { build(:permission_role_without_permission) }

      it 'should be invalid' do
        expect(permission_role).not_to be_valid
      end
    end

    context 'with a permission' do
      it 'should be unique' do
        create :permission_role
        is_expected.to validate_uniqueness_of(:role).scoped_to(:permission_id)
      end
    end
  end
end
