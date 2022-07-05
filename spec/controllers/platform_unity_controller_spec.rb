# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlatformUnitiesController, type: :controller do
  include PermissionHelper
  let(:default_serializer) { V2::PlatformUnitySerializer }
  describe "platformUnity" do
    context '#index' do
      before { user_platform_admin_session }
      before { grant_test_permission('index', user_platform_admin.user) }
      let!(:platformUnity) do
        create(:platform_unity, platform_id: user_platform_admin.platform_id)
      end

      it 'returns a platformUnity' do
        get :index
        platform_unit2 = PlatformUnity.where(platform_id: user_platform_admin.platform_id)
        assert_apiv2_response(:ok, platform_unit2, default_serializer)
      end
    end
    context '#create' do
      before { user_platform_admin_session }
      before { grant_test_permission('create', user_platform_admin.user) }
      let(:create_params) do
        {
          name: 'Example name',
          slug: 'Example slug',
          uf: 'Example uf',
          city: 'Example city'
        }
      end
      it 'creates a new platformUnit' do
        post :create, params: create_params
        assert_apiv2_response(:created, PlatformUnity.last, default_serializer)
      end
    end
    context '#update' do
      before { user_platform_admin_session }
      before { grant_test_permission('update', user_platform_admin.user) }
      let(:platform_slug) { user_platform_admin.platform.slug }
      let(:platformUnity) do
        create(:platform_unity, platform_id: user_platform_admin.platform.id)
      end
      it 'returns a serializad platformUnity json' do
        post :update, params: { id: platformUnity.id,
                                name: 'new_name', uf: 'new_uf', city: 'new_city' }
        assert_apiv2_response(:ok, platformUnity.reload, default_serializer)
      end
    end
    context '#show' do
      before { user_platform_admin_session }
      before { grant_test_permission('show', user_platform_admin.user) }
      let(:platform_slug) { user_platform_admin_admin.platform.slug }
      let(:platformUnity) do
        create(:platform_unity, platform_id: user_platform_admin.platform.id)
      end
      let(:platformUnity2) do
        create(:platform_unity, platform_id: user_platform_admin.platform.id, parent: platformUnity)
      end
      it 'show a platformUnity' do
        get :show, params: { id: platformUnity.id }
        assert_apiv3_response(:ok, platformUnity, V3::PlatformUnitySerializer)
      end
      it 'show a platformUnity with parents' do
        get :show, params: { id: platformUnity2.id }
        assert_apiv3_response(:ok, platformUnity2, V3::PlatformUnitySerializer)
        expect(JSON.parse(response.body)['results']['parents'])
          .to eq([{ "id" => platformUnity.id, "name" => platformUnity.name }])
      end
    end
    context '#destroy' do
      before { user_platform_admin_session }
      before { grant_test_permission('destroy', user_platform_admin.user) }
      let(:platform_slug) { user_platform_admin.platform.slug }
      let!(:platformUnity) do
        create(:platform_unity, platform_id: user_platform_admin.platform.id)
      end
      it 'creates a platformUnity with a custom slug' do
        expect do
          delete :destroy, params: { id: platformUnity.id }
        end.to change(PlatformUnity, :count).by(-1)
      end
    end
  end
end
