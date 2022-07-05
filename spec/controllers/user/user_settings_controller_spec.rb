# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::UserSettingsController, type: :controller do
  include PermissionHelper

  let(:default_serializer) { V2::UserSettingSerializer }
  context 'as user' do
    before { user_session }
    context '#index' do
      context 'as user' do
        context 'with permission' do
          before { grant_test_permission('index') }
          context 'with valid user_settings' do
            let!(:user_setting1) { create(:user_setting, value: { some: 'value-1' }, user: user) }
            let!(:user_setting2) { create(:user_setting, value: { some: 'value-2' }, user: user) }
            it 'returns user_settings' do
              get :index, params: { page: 1 }

              expect(response).to have_http_status(:ok)
              expect(parsed_response['data'].count).to eq(2)
            end
          end
        end
      end
    end

    context '#show' do
      context 'as user' do
        before { user_session }
        context 'with permission' do
          before { grant_test_permission('show') }
          context 'with a valid user_setting' do
            let!(:user_setting) { create(:user_setting, user: user) }
            it 'returns user_setting' do
              get :show, params: { key: user_setting.key }

              expect(response).to have_http_status(:ok)
              expect(parsed_response['data']['attributes']['value']).to eq(user_setting.value)
            end
          end
        end
      end
    end

    context '#upsert' do
      context 'as user' do
        before { user_session }
        context 'with permission' do
          before { grant_test_permission('upsert') }
          context 'with a valid user_setting' do
            let!(:user_setting) { create(:user_setting, value: { some: 'value-2' }, user: user) }
            it 'returns a serializad user_setting json' do
              put :upsert, params: { key: user_setting.key,
                                     value: { some_json_value: 'new_value' } }

              response_value = parsed_response['data']['attributes']['value']
              expect(response_value['some_json_value']).to eq('new_value')
              assert_apiv2_response(:ok, user_setting.reload, default_serializer)
            end
          end
          context 'without an existent user_setting' do
            it 'returns a serializad user_setting json' do
              expect do
                put :upsert, params: { key: 'new_key', value: { some_json_value: 'new_value2' } }
                response_value = parsed_response['data']['attributes']['value']
                expect(response_value['some_json_value']).to eq('new_value2')
              end.to change(UserSetting, :count).by(1)
            end
          end
        end
      end
    end
  end
end
