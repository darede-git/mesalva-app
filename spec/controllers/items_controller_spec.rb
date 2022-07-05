# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  include ContentStructureAssertionHelper
  include RelationshipOrderAssertionHelper
  include PermalinkAssertionHelper
  include PermalinkBuildAssertionHelper

  let(:valid_attributes) { attributes_for(:item) }
  let(:valid_attributes_public_document) { attributes_for(:item, :public_document) }
  let!(:item) { create(:item, valid_attributes) }

  describe 'POST #create' do
    context 'as admin' do
      before { admin_session }
      context 'with valid params' do
        it 'creates a new Item' do
          expect do
            post :create, params: valid_attributes
          end.to change(Item, :count).by(1)
          item = Item.last

          expect(item.created_by).to eq(admin.uid)
          assert_jsonapi_response(:created,
                                  item,
                                  EntityItemSerializer,
                                  %i[media node_modules])
          assert_response_does_not_have_included_relationships
          assert_presence_of_relationships(
            parsed_response['data'],
            %w[media node-modules]
          )
        end
      end

      context 'with invalid params' do
        it 'returns http code 422 unprocessable entity' do
          post :create, params: { name: '' }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'as user' do
      before { user_session }
      context 'with valid params' do
        it 'returns http unauthorized' do
          post :create, params: valid_attributes

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) { attributes_for(:item, name: 'other item') }
    context 'as admin' do
      before { admin_session }
      context 'with valid params' do
        it 'updates the requested item' do
          put :update, params: { id: item, name: 'other item' }

          assert_content_update(item, admin, EntityItemSerializer)
          assert_response_does_not_have_included_relationships
          assert_presence_of_relationships(
            parsed_response['data'],
            %w[media node-modules]
          )
        end
      end
      context 'adding media to item' do
        before do
          @media = create_related_list(:medium)
          @medium_ids = @media.map(&:id)
        end
        it 'should define position for every medium' do
          item.medium_ids = @medium_ids
          item.save

          assert_permalink_build_worker_call('Item', item.id)
          put :update, params: {
            id: item, medium_ids_order: @medium_ids.reverse
          }
          assert_relationship_inclusion_and_ordering(item)
          assert_response_related_entity_ids('media', @medium_ids.reverse)
        end
        it 'creates a permalink for each medium' do
          entities = parents_for(item)

          MeSalva::Permalinks::Builder.new(
            entity_id: entities[:node].parent.id,
            entity_class: 'Node'
          ).build_subtree_permalinks

          assert_permalink_build_worker_call('Item', item.id)
          put :update, params: { id: item, medium_ids: @medium_ids }

          MeSalva::Permalinks::Builder.new(entity_id: item.id,
                                           entity_class: 'Item')
                                      .build_subtree_permalinks
          @media.each do |medium|
            assert_permalink_inclusion(medium.permalinks.first, [
                                         entities[:education_segment]
                                         .permalinks,
                                         entities[:node].permalinks,
                                         entities[:node_module].permalinks,
                                         item.permalinks
                                       ])
            assert_permalink_entities_inclusion(
              medium.permalinks.first,
              node: [entities[:education_segment].id, entities[:node].id],
              node_module: entities[:node_module].id,
              item: item.id,
              medium: medium.id
            )
            expect(medium.permalinks.first.slug).to eq slug_for(
              [
                entities[:education_segment],
                entities[:node],
                entities[:node_module],
                item,
                medium
              ]
            )
          end
        end
      end
      it_should_behave_like 'a removable related entity',
                            [{ self: :item, related: :node_module },
                             { self: :item, related: :medium }]
      it_behaves_like 'controller #update with inactive "has_many" relations',
                      entity: :item, relations: %i[node_module medium]
      context 'with invalid params' do
        it 'returns http code 422 unprocessable entity' do
          put :update, params: { id: item, name: '' }
          expect(assigns(:item)).to eq(item)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
    context 'as user' do
      it_behaves_like 'unauthorized http status for user' do
        let(:name) { 'other node' }
        let(:id) { 'item' }
      end

      context 'when sending platform_id' do
        before { user_session }
        let!(:platform) { create(:platform) }
        let!(:user_platform) do
          create(:user_platform, user_id: user.id, platform_id: platform.id, role: "student")
        end
        let(:parent_node_module_mesalva) { create(:node_module) }
        let(:parent_node_module_platform) { create(:node_module, platform_id: platform.id) }

        it 'cannot update platform items' do
          put :update, params: { id: item.id,
                                 name: 'some other name',
                                 node_module_ids: [parent_node_module_platform.id],
                                 platform_id: platform.id }
          expect(response).to have_http_status(:unauthorized)
        end

        it 'cannot update a item under the mesalva node_module' do
          put :update, params: { id: item.id,
                                 name: 'some other name',
                                 node_module_ids: [parent_node_module_mesalva.id],
                                 platform_id: platform.id }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
    context 'as platform admin' do
      before { user_platform_admin_session }
      let!(:platform) { user_platform_admin.platform }
      let(:parent_node_module_mesalva) { create(:node_module) }
      let(:parent_node_module_platform) { create(:node_module, platform_id: platform.id) }

      it 'can update an item under the platform node_module' do
        put :update, params: { id: item.id,
                               name: 'some other name',
                               node_module_ids: [parent_node_module_platform.id] }

        expect(response).to have_http_status(:ok)
      end

      it 'cannot update an item under the mesalva node_module' do
        put :update, params: { id: item.id,
                               name: 'some other name',
                               node_module_ids: [parent_node_module_mesalva.id] }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'search datum' do
      let!(:search_data) { create(:search_datum, item_id: item.id) }

      it 'updates search data that ends with entity' do
        item.update(name: 'some name')
        search_data.reload

        expect(search_data.name).to eq('some name')
      end
    end
  end

  describe '#streaming_index' do
    context 'has streaming' do
      let!(:streaming) { create(:item, :scheduled_streaming) }
      let!(:next_day_streaming) do
        create(:item, :scheduled_streaming,
               starts_at: Date.tomorrow, ends_at: Date.tomorrow + 1.hour)
      end
      before do
        create(:permalink, item_id: streaming.id)
        create(:permalink, item_id: next_day_streaming.id)
      end
      context 'with ends_at param' do
        it 'list streaming items until end_date param' do
          get :streaming_index, params: { ends_at: Time.now + 2.days }

          assert_jsonapi_response(:ok, [streaming, next_day_streaming], ItemSerializer)
        end
      end

      context 'with starts_at param' do
        it 'list streaming items based on starts_at param' do
          get :streaming_index, params: { starts_at: Date.tomorrow }

          assert_jsonapi_response(:ok, [next_day_streaming], ItemSerializer)
        end
      end

      context 'with both params' do
        it 'slice period before list' do
          get :streaming_index, params: { starts_at: Date.today, ends_at: Date.tomorrow }

          assert_jsonapi_response(:ok, [streaming], ItemSerializer)
        end
      end

      context 'without param' do
        it 'list based on current date' do
          get :streaming_index

          assert_jsonapi_response(:ok, [streaming, next_day_streaming], ItemSerializer)
        end
      end
    end
    context 'has not streaming' do
      it 'return empty array' do
        get :streaming_index
        assert_jsonapi_response(:ok, [], ItemSerializer)
      end
    end

    context 'as user' do
      before { user_session }
      let!(:node_fac) { create(:node) }
      let!(:node_module_fac) { create(:node_module, nodes: [node_fac]) }
      let!(:streaming) do
        create(:item, :scheduled_streaming,
               starts_at: Date.tomorrow, node_modules: [node_module_fac])
      end
      let!(:package_fac) { create(:package_valid_with_price, nodes: [node_fac]) }
      let!(:acesso) { create(:access, package: package_fac, user: user, expires_at: Date.tomorrow) }

      it 'return empty array' do
        get :streaming_index, params: { starts_at: Date.tomorrow }
        assert_jsonapi_response(:ok, [streaming], ItemSerializer)
      end
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'a destroyed request' do
      let(:id) { item }
      let(:model) { Item }
    end

    it 'destroys search data related to entity' do
      create(:search_datum, item_id: item.id)

      expect { item.destroy }.to change(SearchDatum, :count).by(-1)
    end
  end
end
