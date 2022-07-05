# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  include PermissionHelper
  let(:default_serializer) { V3::RoleSerializer }

  describe "roles" do
    before { user_session }
    context '#index' do
      let!(:granted_permission) { grant_test_permission('index') }

      it 'returns all roles' do
        get :index
        assert_apiv2_response(:ok, [granted_permission[:role]], default_serializer)
      end
    end
    context '#show' do
      before { grant_test_permission('show') }
      let!(:role) { create(:role) }

      it 'select the requested role' do
        get :show, params: { slug: role.slug }
        assert_apiv2_response(:ok, role, default_serializer)
      end
    end
    context '#create' do
      before { grant_test_permission('create') }

      it 'creates a new role' do
        post :create, params: { name: 'some_role' }
        assert_apiv2_response(:created, Role.last, default_serializer)
      end
    end
    context '#update' do
      before { grant_test_permission('update') }
      let!(:role) { create(:role) }

      it 'return modified requested role' do
        put :update, params: { slug: role.slug, name: 'new_name' }
        assert_apiv2_response(:ok, role.reload, default_serializer)
      end
    end
    context '#destroy' do
      before { grant_test_permission('destroy') }
      let!(:role) { create(:role) }

      it 'destroy the requested role' do
        expect do
          delete :destroy, params: { slug: role.slug }
        end.to change(Role, :count).by(-1)
      end
    end
  end
end
