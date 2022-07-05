# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SystemSettingsController, type: :controller do
  include PermissionHelper

  let(:default_serializer) { V2::SystemSettingSerializer }

  context 'as user' do
    before { user_session }

    context '#index' do
      context 'with permission' do
        before { grant_test_permission('index') }
        context 'with valid system_settings' do
          let!(:system_setting1) { create(:system_setting) }
          let!(:system_setting2) { create(:system_setting) }
          it 'returns system_settings' do
            get :index
            assert_apiv2_response(:ok, [system_setting1, system_setting2], default_serializer)
          end
        end
      end
    end

    context '#show' do
      context 'with permission' do
        before { grant_test_permission('show') }
        context 'with a valid system_setting' do
          let!(:system_setting) { create(:system_setting) }
          it 'returns system_setting' do
            get :show, params: { key: system_setting.key }
            assert_apiv2_response(:ok, system_setting, default_serializer)
          end
        end
      end
    end

    context '#update' do
      context 'with permission' do
        before { grant_test_permission('update') }
        context 'with a valid system_setting' do
          let!(:system_setting) { create(:system_setting) }
          it 'returns a serializad system_setting json' do
            put :update, params: { key: system_setting.key, value: { new: 'value' } }
            assert_apiv2_response(:ok, system_setting.reload, default_serializer)
            expect(system_setting.reload.value["new"]).to eq('value')
          end
        end
      end
    end

    context '#create' do
      context 'with permission' do
        before { grant_test_permission('create') }
        let!(:valid_attributes) { attributes_for(:system_setting) }
        context 'with valid params' do
          it 'creates a system_setting' do
            expect do
              post :create, params: valid_attributes
            end.to change(SystemSetting, :count).by(1)

            assert_apiv2_response(:created, SystemSetting.last, default_serializer)
          end
        end
      end
    end

    context '#destroy' do
      context 'with permission' do
        before { grant_test_permission('destroy') }
        context 'with a valid system_setting' do
          let!(:system_setting) { create(:system_setting) }
          it 'destroy a system_setting' do
            expect do
              delete :destroy, params: { key: system_setting.key }
            end.to change(SystemSetting, :count).by(-1)
          end
        end
      end
    end
  end
end
