# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TangibleProductsController, type: :controller do
  include PermissionHelper

  let(:default_serializer) { V2::TangibleProductSerializer }

  context 'as user' do
    before { user_session }

    context '#index' do
      context 'with permission' do
        before { grant_test_permission('index') }
        context 'with valid tangible_products' do
          let!(:tangible_product1) { create(:tangible_product) }
          let!(:tangible_product2) { create(:tangible_product) }
          it 'returns tangible_products' do
            get :index
            assert_apiv2_response(:ok, [tangible_product1, tangible_product2], default_serializer)
          end
        end
      end
    end

    context '#show' do
      context 'with permission' do
        before { grant_test_permission('show') }
        context 'with a valid tangible_product' do
          let!(:tangible_product) { create(:tangible_product) }
          it 'returns tangible_product' do
            get :show, params: { id: tangible_product.id }
            assert_apiv2_response(:ok, tangible_product, default_serializer)
          end
        end
      end
    end

    context '#update' do
      context 'with permission' do
        before { grant_test_permission('update') }
        context 'with a valid tangible_product' do
          let!(:tangible_product) { create(:tangible_product) }
          it 'returns a serializad tangible_product json' do
            put :update, params: { id: tangible_product.id, name: 'new_value' }
            assert_apiv2_response(:ok, tangible_product.reload, default_serializer)
            expect(tangible_product.name).to eq('new_value')
          end
        end
      end
    end

    context '#create' do
      context 'with permission' do
        before { grant_test_permission('create') }
        let!(:valid_attributes) { attributes_for(:tangible_product) }
        context 'with valid params' do
          it 'creates a tangible_product' do
            expect do
              post :create, params: valid_attributes
            end.to change(TangibleProduct, :count).by(1)

            assert_apiv2_response(:created, TangibleProduct.last, default_serializer)
          end
        end
      end
    end

    context '#destroy' do
      context 'with permission' do
        before { grant_test_permission('destroy') }
        context 'with a valid tangible_product' do
          let!(:tangible_product) { create(:tangible_product) }
          it 'destroy a tangible_product' do
            expect do
              delete :destroy, params: { id: tangible_product.id }
            end.to change(TangibleProduct, :count).by(-1)
          end
        end
      end
    end
  end
end
