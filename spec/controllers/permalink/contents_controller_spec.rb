# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.describe Permalink::ContentsController, type: :controller do
  include SerializationHelper
  include PermalinkAssertionHelper
  include PermalinkCreationHelper

  include_context 'permalink building'

  let(:node4) { create(:node_subject, parent_id: node2.id) }
  let!(:medium2) { create(:medium_pdf, nodes: [node4]) }
  let!(:education_segment) { create(:node) }
  let!(:permalink) do
    create(
      :permalink,
      slug: "#{node1.slug}/#{node2.slug}/#{node3.slug}",
      nodes: [node1, node2, node3]
    )
  end
  let(:package) { create(:package_valid_with_price) }

  before { Timecop.freeze(Time.at(1_474_034_684).utc) }
  after { Timecop.return }

  describe 'GET #show' do
    it 'returns the requested permalink entities as metadata' do
      get :show, params: { slug: complete_permalink.slug }

      expect(response.headers.keys).not_to include_authorization_keys
      response_data = parsed_structure(response.body, 'body')
      jsonapi = to_jsonapi(complete_permalink, Permalink::PermalinkSerializer)
      serializer_data = parsed_structure(jsonapi, 'body')

      response_meta = parsed_structure(response.body, 'meta')
      response_meta_entities = response_meta['entities']

      expect(response_data).to eq(serializer_data)
      expect(response_meta.keys).to include('entities')

      expect(deep_array_key_fix(complete_permalink.entities).first(4))
        .to match response_meta_entities.first 4
    end

    context 'when permalink does not exists' do
      it 'returns error code 404' do
        get :show, params: { slug: 'invalid/slug' }
        assert_type_and_status(:not_found)

        expect(parsed_response['errors'])
          .to eq([t('permalink.invalid_entities')])
      end
    end

    context 'when permalink has no entities' do
      it 'returns an error message' do
        empty_permalink = FactoryBot
                          .create(:permalink, slug: 'empty/permalink')
        get :show, params: { slug: empty_permalink.slug }

        assert_type_and_status(:not_found)
        expect(parsed_response['errors'])
          .to eq [t('permalink.invalid_entities')]
      end
    end

    context 'when permalink has inactive entities' do
      it 'returns an error message' do
        permalink = create(:permalink, slug: 'inactive/slug')
        node_module = create(:node_module, active: false)
        item = create(:item)
        node_module.items = [item]

        create(:node, permalink_ids: [permalink.id])
        permalink.node_module_id = node_module.id
        permalink.item_id = item.id
        permalink.save

        get :show, params: { slug: permalink.slug }

        assert_type_and_status(:not_found)
        expect(response).to have_http_status(:not_found)
        expect(parsed_response['errors'])
          .to eq [t('permalink.invalid_entities')]
      end
    end

    context 'when last entity is medium' do
      before do
        user_session
        get :show, params: { slug: complete_permalink.slug }
      end

      it 'returns the last entity with item serializer' do
        medium_attrs = { 'id' => medium.id,
                         'name' => medium.name,
                         'slug' => medium.slug,
                         'entity-type' => 'medium' }

        assert_type_and_status(:ok)
        assert_entity_type_and_slug('medium')
        expect(response_last_entity).to eq(medium_attrs)
        expect(response_last_entity).not_to have_key('status-code')
      end
    end

    context 'last entity is item' do
      before do
        @permalink = create(:permalink, slug: 'slug')
        node_module = create(:node_module)
        item = create(:item)
        node_module.items = [item]
        create(:node, permalink_ids: [@permalink.id])
        @permalink.node_module_id = node_module.id
        @permalink.item_id = item.id
        @permalink.save
      end

      context 'when it has no medium' do
        it 'returns the last entity with item serializer' do
          get :show, params: { slug: @permalink.slug }

          item_attrs = deep_key_fix(
            entity_serializable_hash('Content', @permalink.item)
          )

          assert_type_and_status(:ok)
          assert_entity_type_and_slug('item')
          expect(response_last_entity).to eq(item_attrs)
          expect(response_last_entity.keys).not_to include 'node-modules'
          expect(response_last_entity.keys).not_to include 'medium-ids'
          expect(response_last_entity.keys).to include 'media'
          expect(response_last_entity).to have_key('downloadable')
        end
      end

      context 'when it has a medium' do
        it 'returns only medium slugs and types' do
          @permalink.item.medium_ids = [medium.id]
          get :show, params: { slug: @permalink.slug }

          assert_type_and_status(:ok)
          media = [
            { 'slug' => medium.slug,
              'options' => {},
              'medium-type' => medium.medium_type }
          ].as_json
          expect(response_last_entity['media']).to eq(media)
        end
      end
      context 'item has inactive relatives' do
        before do
          complete_permalink.node_module.update(active: true)
          complete_permalink.update(medium_id: nil)
        end
        it_behaves_like 'permalink with inactive entity relatives',
                        entity: :item, relations: %i[medium] do
          let(:permalink_id) { complete_permalink.id }
          let(:entity_id) { complete_permalink.item_id }
        end
      end
    end

    context 'last entity is node_module' do
      before do
        parsed_entities(permalink_entities_module)
        item.node_module_ids = [permalink.node_module_id]
        item.save

        medium.node_module_ids = [permalink.node_module_id]
        medium.save
      end

      it 'returns the last entity with module serializer' do
        get :show, params: { slug: permalink.slug }

        node_module_attrs = deep_key_fix(
          entity_serializable_hash('Content', permalink.node_module)
        )
        item_attrs = deep_key_fix(
          Content::Relation::NodeModuleItemSerializer.new(
            item,
            accessible_permalink: true
          ).as_json
        )
        medium_attributes = medium_attrs(medium)
        medium_attributes.delete('answers')

        assert_type_and_status(:ok)
        assert_entity_type_and_slug('node_module')

        expect(node_module_attrs.keys).to include 'instructor'
        expect(response_last_entity['entity-type']).to eq 'node_module'
        assert_permalink_last_entity_relation_not_to_have_keys(
          'items', %w[
            media
            node_modules
            medium-ids
          ]
        )
        response_last_entity['items'].each do |i|
          expect(i).to eq item_attrs
        end

        response_last_entity['media'].each do |m|
          expect(m).to eq medium_attributes
        end
      end
      context 'node module has inactive relatives' do
        it_behaves_like 'permalink with inactive entity relatives',
                        entity: :node_module, relations: %i[item medium] do
          let(:permalink_id) { permalink.id }
          let(:entity_id) { permalink.node_module.id }
        end
      end
    end

    context 'last entity is node education_segment' do
      it 'returns the entity type and slug' do
        education_segment = create(:node)
        course = create(:node, node_type: 'course',
                               parent_id: education_segment.id)
        @area = create(:node, node_type: 'area',
                              parent_id: course.id,
                              color_hex: 'ED4343')
        MeSalva::Permalinks::Builder.new(entity_id: education_segment.id,
                                         entity_class: 'Node')
                                    .build_subtree_permalinks

        get :show, params: { slug: education_segment.slug }

        assert_entity_type_and_slug('node')
      end
    end

    context 'last entity is node with children' do
      before do
        parsed_entities(permalink_entities_node)
        permalink.nodes.last.node_module_ids = [node_module.id]
        permalink.nodes.last.medium_ids = [medium.id]
        permalink.nodes.last.save
        node4.parent_id = permalink.nodes.last.id
        node4.save

        get :show, params: { slug: permalink.slug }
      end

      it 'returns the last entity with node serializer' do
        assert_type_and_status(:ok)
        node_attrs = deep_key_fix(
          entity_serializable_hash('Content', permalink.nodes.last).as_json
        )
        node_module.reload
        node_module_attrs = deep_key_fix(
          Content::Relation::NodeNodeModuleSerializer.new(node_module).as_json
        )

        assert_entity_type_and_slug('node')
        expect(response_last_entity).to eq(node_attrs)
        expect(response_last_entity['entity-type']).to eq 'node'
        assert_permalink_last_entity_relation_not_to_have_keys(
          'media', %w[items nodes]
        )

        expect(node_module_attrs.keys).not_to include 'seconds-duration'

        response_last_entity['node-modules'].each do |m|
          expect(m).to eq node_module_attrs
        end
      end
    end
    context 'node has inactive relatives' do
      before do
        permalink.nodes.last.media = [create(:medium)]
      end
      it_behaves_like 'permalink with inactive entity relatives',
                      entity: :node, relations: %i[node_module medium] do
        let(:permalink_id) { permalink.id }
        let(:entity_id) { permalink.nodes.last.id }
      end
    end

    context 'all entities are nodes' do
      types = %w[area course cycle department
                 study_plan subject year prep_test]

      types.each do |type|
        it "renders type #{type} with its own serializer" do
          node = create(:node,
                        node_type: type,
                        color_hex: 'ED4343',
                        parent_id: education_segment.id)
          MeSalva::Permalinks::Builder.new(entity_id: education_segment.id,
                                           entity_class: 'Node')
                                      .build_subtree_permalinks

          serialized_node = serialize(node)
          attrs = deep_key_fix(serialized_node)

          get :show, params: { slug: "#{education_segment.slug}/#{node.slug}" }

          expect(response_last_entity).to eq(attrs)
        end
      end
    end
    context 'node has study tools as children' do
      before do
        parent_id = permalink.nodes.first.id
        Node::STUDY_TOOLS.each do |node_type|
          create(:node,
                 parent_id: parent_id,
                 node_type: node_type,
                 name: node_type)
        end
        @area = create(:node_area, parent_id: parent_id)

        MeSalva::Permalinks::Builder
          .new(entity_id: parent_id, entity_class: 'Node')
          .build_subtree_permalinks
      end
      it 'does not list study tools as children' do
        get :show, params: { slug: permalink.nodes.first.slug }

        expect(response_last_entity['children'].count).to eq 2
        expect(permalink.nodes.first.children.count)
          .to eq(Node::STUDY_TOOLS.count + 2)
        children = response_last_entity['children'].map { |c| c['slug'] }
        expect(children).to eq [permalink.nodes.second.slug, @area.slug]
      end
    end
  end

  def serialize(node)
    'Content::NodeSerializer'.constantize.new(node).as_json
  end

  def medium_attrs(medium = complete_permalink.medium)
    deep_key_fix(Content::Relation::ChildMediumSerializer.new(medium).as_json)
  end

  def assert_entity_type_and_slug(type)
    expect(response_last_entity['entity-type']).to eq(type)
    expect(response_last_entity).to have_key('slug')
  end
end
