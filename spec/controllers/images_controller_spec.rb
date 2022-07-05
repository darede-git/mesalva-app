# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesController, type: :controller do
  include ContentStructureAssertionHelper
  include PermissionHelper

  let!(:image) { create(:image) }
  let!(:valid_attributes) { FactoryBot.attributes_for(:image) }

  describe '#create' do
    context 'as user platform admin' do
      before { user_platform_admin_session }
      before { grant_test_permission('create', user_platform_admin.user) }
      context 'with valid params' do
        it 'creates one new Image' do
          expect do
            post :create, params: valid_attributes
          end.to change(Image, :count).by(1)
          expect(parsed_response['data']['attributes']['created-by'])
            .to eq(user_platform_admin.user.uid)
          expect(response.status).to eq(201)
        end
      end

      context 'with invalid params' do
        it 'returns http unprocessable_entity' do
          post :create, params: { image: nil }
          expect(parsed_response['errors']).to eq([{ "image" => ["não pode ficar em branco"] }])
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe '#destroy' do
    context 'as admin' do
      before { user_platform_admin_session }
      before { grant_test_permission('destroy', user_platform_admin.user) }
      it 'destroys the requested image' do
        expect do
          delete :destroy, params: { id: image.id }
        end.to change(Image, :count).by(-1)

        expect(response).to have_http_status(:no_content)
        expect(response.content_type).to eq(nil)
      end
    end
  end
end
