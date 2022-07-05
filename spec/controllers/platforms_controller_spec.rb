# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlatformsController, type: :controller do
  let(:default_serializer) { V2::PlatformSerializer }
  context 'valid params' do
    let!(:platform) do
      create(:platform)
    end
    let!(:platform_unity) do
      create(:platform_unity, platform_id: platform.id)
    end
    context '#show' do
      it 'returns a platform' do
        user_platform_session
        get :show, params: { platform_slug: platform.slug }
        assert_apiv2_response(:ok, platform, default_serializer, %i[platform_unities])
      end
    end
    context '#update' do
      before { user_platform_admin_session }
      let(:platform) { user_platform_admin.platform }
      it 'returns a serializad platform json' do
        post :update, params: { platform_slug: platform.slug, name: 'new_name', slug: 'new_slug' }
        result = parsed_response['data']['attributes']
        expect(result['name']).to eq('new_name')
        expect(result['slug']).to eq('new_slug')
      end
    end
  end
  context '#create' do
    before { user_platform_admin_session }
    let(:name) { 'Example Platform' }
    let(:cnpj) { "99.999.999/0001-99" }
    it 'creates a platform with a custom slug' do
      post :create, params: { name: name, cnpj: cnpj }
      expect(response).to have_http_status(:created)
      result = parsed_response['data']['attributes']
      expect(result['slug']).to include('example-platform-')
    end
  end
end
