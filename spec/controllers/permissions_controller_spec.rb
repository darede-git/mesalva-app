# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PermissionsController, type: :controller do
  include PermissionHelper
  let(:default_serializer) { V3::PermissionSerializer }

  describe "permissions" do
    before { user_session }
    context '#index' do
      let!(:granted_permission) { grant_test_permission('index') }
      let!(:ungranted_permission) do
        create(:permission,
               context: 'other_context',
               action: 'other_action')
      end

      it 'returns all permissions' do
        get :index
        permission = granted_permission[:permission]
        expect(response).to have_http_status(:ok)

        first_permission = parsed_response['results'].last
        expect(first_permission['context']).to eq(ungranted_permission.context)
        expect(first_permission['action']).to eq(ungranted_permission.action)

        last_permission = parsed_response['results'].first
        expect(last_permission['context']).to eq(permission.context)
        expect(last_permission['action']).to eq(permission.action)
      end
    end
    context '#by_role' do
      let!(:granted_permission) { grant_test_permission('by_role') }
      let!(:role) { create(:role) }
      let!(:permission1) { create(:permission) }
      let!(:permission2) { create(:permission) }
      before do
        create(:permission_role, permission: permission1, role: role)
        create(:permission_role, permission: permission2, role: role)
      end

      it 'returns all permissions with role permitted attribute' do
        get :by_role, params: { role_slug: role.slug }
        expect(parsed_response['results']).to eq(
          [by_role_mock(permission1, true),
           by_role_mock(permission2, true),
           by_role_mock(granted_permission[:permission], false)]
        )
      end
    end
    context '#create' do
      let!(:granted_permission) { grant_test_permission('create') }
      let(:valid_permission) do
        { action_name: "create", context: "images-3",
          permission_type: "route" }
      end

      it 'creates a new permission' do
        post :create, params: valid_permission
        assert_apiv2_response(:created, Permission.last, default_serializer)
      end
    end
    context '#update' do
      let!(:granted_permission) { grant_test_permission('update') }
      let(:permission) { create(:permission) }

      it 'return modified permission' do
        put :update, params: {
          context: permission.context,
          action_name: permission.action,
          permission_type: 'feature_flag'
        }
        assert_apiv2_response(:ok, permission.reload, default_serializer)
      end
    end
    context '#show' do
      let!(:granted_permission) { grant_test_permission('show') }
      let(:permission) { create(:permission) }
      it 'select the requested permission' do
        get :show, params: { action_name: permission.action, context: permission.context }
        assert_apiv2_response(:ok, permission, default_serializer)
      end
    end
    context '#destroy' do
      let!(:granted_permission) { grant_test_permission('destroy') }
      let!(:permission) { create(:permission) }
      it 'destroy the requested permission if not used' do
        expect do
          delete :destroy, params: { action_name: permission.action, context: permission.context }
        end.to change(Permission, :count).by(-1)
      end
      it 'do not destroy the requested permission if not used' do
        expect do
          delete :destroy, params: { context: granted_permission[:permission].context,
                                     action_name: granted_permission[:permission].action }
        end.to change(Permission, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  def by_role_mock(permission, permitted)
    {
      "id" => permission.id,
      "action" => permission.action,
      "context" => permission.context,
      "description" => permission.description,
      "permission_type" => permission.permission_type,
      "permitted" => permitted
    }
  end
end
