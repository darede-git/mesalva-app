# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSettingsController, type: :controller do
  include PermissionHelper

  let(:default_serializer) { V2::UserSettingSerializer }

  describe "user settings" do
    context '#index' do
      before { user_session }
      before { grant_test_permission('index') }
      context 'without user settings' do
        let!(:user) { create(:user) }
        let!(:user_settings) { create(:user_setting, user_id: user.id) }
        it 'returns all user settingsr' do
          get :index, params: { user_uid: user.uid }

          assert_apiv2_response(:ok, [user_settings], default_serializer)
        end
      end
    end

    context '#show' do
      before { user_session }
      before { grant_test_permission('show') }
      context 'without user settings' do
        let!(:user) { create(:user) }
        let!(:user_settings) { create(:user_setting, user_id: user.id) }
        it 'returns a user settingsr' do
          get :show, params: { user_uid: user.uid, key: user_settings.key, user: user }

          assert_apiv2_response(:ok, user_settings, default_serializer)
        end
      end
    end

    context '#update' do
      before { user_session }
      before { grant_test_permission('update') }
      context 'without user settings' do
        let!(:user) { create(:user) }
        let!(:user_settings) { create(:user_setting, user_id: user.id) }
        it 'returns a user settingsr' do
          get :update, params: { user_uid: user.uid,
                                 key: user_settings.key,
                                 user: user,
                                 value: user_settings.value }

          assert_apiv2_response(:ok, user_settings, default_serializer)
        end
      end
    end

    context '#destroy' do
      before { user_session }
      before { grant_test_permission('destroy') }
      context 'without user settings' do
        let!(:user) { create(:user) }
        let!(:user_settings) { create(:user_setting, user_id: user.id) }
        it 'destroy a user settingsr' do
          get :destroy, params: { user_uid: user.uid,
                                  key: user_settings.key,
                                  user: user,
                                  value: user_settings.value }

          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end
end
