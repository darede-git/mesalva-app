# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NodesController, type: :controller do
  include ContentStructureAssertionHelper
  include RelationshipOrderAssertionHelper
  include PermalinkBuildAssertionHelper

  let(:valid_attributes) { FactoryBot.attributes_for(:node) }
  let(:invalid_attributes) { FactoryBot.attributes_for(:node, name: '') }
  let!(:node) { create(:node, valid_attributes) }
  let!(:node_children) do
    create(:node_area,
           parent_id: node.id)
  end

  describe 'POST #create' do
    context 'as admin' do
      before { admin_session }
      context 'with valid params' do
        it 'creates a new Node' do
          expect do
            post :create, params: valid_attributes.merge(name: 'name',
                                                         position: 1)
          end.to change(Node, :count).by(1)
          node = Node.last

          expect(node.created_by).to eq(admin.uid)
          expect(node.position).to eq 1
          assert_jsonapi_response(:created, node, EntityNodeSerializer)
          assert_response_does_not_have_included_relationships
          assert_presence_of_relationships(
            parsed_response['data'],
            %w[media node-modules]
          )
        end

        context 'including node_module_ids' do
          before :each do
            @node_module = create(:node_module)
          end
          it 'should ignore node modules on creating a new node' do
            expect do
              post :create, params: node_area_attrs
            end.to change(Node, :count).by(1)

            node = Node.last

            expect(node.permalinks).to be_empty
            expect(node.node_modules).to be_empty
          end
        end

        context 'on node type education_segment' do
          before :each do
            assert_permalink_build_worker_call('Node', next_node_id)

            post :create, params: valid_attributes

            @node = parsed_response
          end
          it 'should not save node when permalink already exists' do
            Permalink.create(slug: valid_attributes[:name])

            expect do
              Node.create(name: valid_attributes[:name],
                          node_type: valid_attributes[:node_type])
            end.to change(Node, :count).by(0)
          end

          context 'updating node' do
            before :each do
              @node = create(:node)
              MeSalva::Permalinks::Builder.new(entity_id: @node.id,
                                               entity_class: 'Node')
                                          .build_subtree_permalinks
            end
            context 'params has node_module_ids' do
              it 'should create a permalink for both entities' do
                node_module = create(:node_module)

                assert_permalink_build_worker_call(
                  'Node', @node.id
                )
                put :update, params: { id: @node.id,
                                       node_module_ids: [node_module.id] }
              end
            end
          end
        end
        context 'on node type != education_segment' do
          before :each do
            post :create, params: FactoryBot.attributes_for(:node_subject)

            @node_response = parsed_response
            @node = Node.find(@node_response['data']['id'])
          end

          it 'should not create a root permalink' do
            expect(@node.permalinks).to be_empty
          end

          context 'when node has parent' do
            before :each do
              @parent_node = create(:node)
            end

            it 'should create a permalink with both entities' do
              expect do
                put :update, params: { id: @node.id,
                                       parent_id: @parent_node.id }
              end.to change(Permalink, :count).by(0)

              expect do
                MeSalva::Permalinks::Builder.new(entity_id: @parent_node.id,
                                                 entity_class: 'Node')
                                            .build_subtree_permalinks
              end.to change(Permalink, :count).by(2)

              permalink = Permalink.last
              expect(permalink.slug).to eq "#{@parent_node.slug}/#{@node.slug}"
            end
          end

          context 'when parent node has as a parent' do
            it 'should create a permalink for all entities' do
              grand_parent = create(:node, name: 'bolo')
              parent = create(:node_area,
                              name: 'thales',
                              parent_id: grand_parent.id)

              MeSalva::Permalinks::Builder.new(entity_id: grand_parent.id,
                                               entity_class: 'Node')
                                          .build_subtree_permalinks

              node_subject_attributes = FactoryBot.attributes_for(
                :node_subject,
                name: 'jader',
                parent_id: parent.id
              )

              assert_permalink_build_worker_call(
                'Node', next_node_id
              )

              post :create, params: node_subject_attributes

              @node_response = parsed_response
              @node = Node.find(@node_response['data']['id'])

              MeSalva::Permalinks::Builder.new(entity_id: Node.last.id,
                                               entity_class: 'Node')
                                          .build_subtree_permalinks

              expect(Permalink.count).to eq 3

              expect(@node.permalinks.last.slug)
                .to eq "#{grand_parent.slug}/#{parent.slug}/#{@node.slug}"

              expect(grand_parent.permalinks.count).to eq 3
              expect(parent.permalinks.count).to eq 2
              expect(@node.permalinks.count).to eq 1

              expect(grand_parent.permalinks).to include @node.permalinks.first
              expect(parent.permalinks).to include @node.permalinks.first

              expect(Permalink.last.node_ids).to match([grand_parent.id,
                                                        parent.id,
                                                        @node.id])
            end
          end
        end
      end

      context 'with invalid params' do
        it 'returns code 422' do
          expect do
            post :create, params: { name: '' }
          end.to change(Node, :count).by(0)

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

      context 'using platform id param' do
        let!(:platform) { create(:platform) }

        it 'render unathorized' do
          post :create, params: valid_attributes.merge(platform_id: platform.id)

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'as platform admin' do
      before { user_platform_admin_session }

      it 'can create a new node under the platform node' do
        expect do
          post :create, params: valid_attributes
        end.to change(Node, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) do
      FactoryBot.attributes_for(:node, name: 'other node')
    end

    context 'as admin' do
      before { admin_session }
      context 'with valid params' do
        it 'updates the requested node' do
          put :update, params: { id: node, name: 'other node' }

          assert_content_update(node, admin, EntityNodeSerializer)
          assert_response_does_not_have_included_relationships

          assert_presence_of_relationships(
            parsed_response['data'],
            %w[media node-modules]
          )
        end

        it 'updates the requested node with listed flag' do
          put :update, params: { id: node, listed: false }

          node.reload
          expect(node.listed).to eq false
          assert_jsonapi_response(:ok, node, EntityNodeSerializer)
        end

        context 'updating a children node' do
          it 'reindexes the parent node' do
            expect(AlgoliaObjectIndexWorker)
              .to receive(:perform_async).with(Node, node.id)

            put :update, params: { id: node_children,
                                   name: 'some other name' }
          end
        end
      end

      context 'adding node_modules to node' do
        before do
          @node_modules = create_related_list(:node_module)
          @node_module_ids = @node_modules.map(&:id)
        end
        it 'should define position for every node_module' do
          node.node_module_ids = @node_module_ids
          node.save

          put :update, params: {
            id: node, node_module_ids_order: @node_module_ids.reverse
          }

          assert_relationship_inclusion_and_ordering(node)
          assert_response_related_entity_ids(
            'node-modules', @node_module_ids.reverse
          )
        end
      end
      it_should_behave_like 'a removable related entity',
                            [{ self: :node, related: :node_module },
                             { self: :node, related: :medium }]

      context "when removing parent node from child" do
        it 'removes parent relation' do
          child_node = node.children.first

          put :update, params: { id: child_node, parent_id: nil }

          node.reload
          child_node.reload

          expect(child_node.parent).to be_nil
          expect(node.children).to be_empty
        end
      end

      context 'with invalid params' do
        it 'should not update the node' do
          put :update, params: { id: node.to_param, name: '' }

          expect(assigns(:node)).to eq(node)
          expect(node.name).not_to eq invalid_attributes[:name]
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
      it_behaves_like 'controller #update with inactive "has_many" relations',
                      entity: :node, relations: %i[node_module medium]
    end
    context 'as user' do
      it_behaves_like 'unauthorized http status for user' do
        let(:name) { 'other node' }
        let(:id) { 'node' }
      end

      context 'when sending platform_id' do
        before { user_session }
        let!(:platform) { create(:platform) }
        let!(:user_platform) do
          create(:user_platform,
                 user_id: user.id,
                 platform_id: platform.id,
                 role: "student")
        end
        let(:parent_node_mesalva) { create(:node) }
        let(:parent_node_platform) { create(:node, platform_id: platform.id) }

        it 'cannot update platform nodes' do
          put :update, params: { id: node.id,
                                 name: 'some other name',
                                 node_ids: [parent_node_platform.id],
                                 platform_id: platform.id }
          expect(response).to have_http_status(:unauthorized)
        end

        it 'cannot update a node under the mesalva node' do
          put :update, params: { id: node.id,
                                 name: 'some other name',
                                 node_ids: [parent_node_mesalva.id],
                                 platform_id: platform.id }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
    context 'as platform admin' do
      before { user_platform_admin_session }

      let(:parent_node_mesalva) { create(:node) }
      let(:parent_node_platform) do
        create(:node, platform_id: user_platform_admin.platform.id)
      end

      it 'can update a node under the platform node' do
        put :update, params: { id: node.id,
                               name: 'some other name',
                               node_ids: [parent_node_platform.id] }
        expect(response).to have_http_status(:ok)
      end

      it 'cannot update a node under the mesalva node' do
        put :update, params: { id: node.id,
                               name: 'some other name',
                               node_ids: [parent_node_mesalva.id] }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as admin' do
      it 'destroys the requested node' do
        admin_session

        expect do
          delete :destroy, params: { id: node }
        end.to change(Node, :count).by(-1)

        expect(response).to have_http_status(:no_content)
        expect(AlgoliaObjectIndexWorker).not_to receive(:perform_async)
      end
    end
    context 'as user' do
      it 'returns http unauthorized' do
        user_session
        delete :destroy, params: { id: node }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  def next_node_id
    Node.maximum(:id).next
  end

  def node_area_attrs
    FactoryBot.attributes_for(:node_area, node_module_ids: [@node_module.id])
  end
end
