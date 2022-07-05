# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permission, type: :model do
  describe 'Validations' do
    context 'with a valid permission' do
      let(:permission) { build(:permission) }

      it 'should be valid' do
        expect(permission).to be_valid
      end
    end

    context 'without controller' do
      let(:permission) { build(:permission_controller_blank) }

      it 'should be invalid' do
        expect(permission).not_to be_valid
      end
    end

    context 'without action' do
      let(:permission) { build(:permission_action_blank) }

      it 'should be invalid' do
        expect(permission).not_to be_valid
      end
    end
  end

  let!(:permission_created) do
    create(:permission, context: 'controller_example', action: 'action_example')
  end
  let!(:role_created) { create(:role) }
  let!(:permission_role_created) do
    create(:permission_role, permission: permission_created, role: role_created)
  end
  let!(:user_role_created) do
    create(:user_role, role: role_created, user: user, user_platform: user_platform)
  end

  describe '#validate_user' do
    context 'method' do
      it 'get a permission through a user role' do
        permission_user_role = Permission.validate_user('controller_example',
                                                        'action_example',
                                                        user)
        expect(permission_user_role).to eq(true)
      end
    end
  end
end
