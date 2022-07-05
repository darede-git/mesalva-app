# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/postgres/materialized_views'

RSpec.describe Permalink, type: :model do
  include ContentStructureCreationHelper

  context 'validations' do
    should_be_present(:slug)

    it 'should verify slug uniqueness' do
      create(:permalink, slug: 'abc')
      duplicated = FactoryBot.build(:permalink, slug: 'abc')
      expect(duplicated).not_to be_valid
    end

    should_have_many(:nodes, :permalinks)
    should_belong_to(:permalink, :node_module, :item, :medium)
    context 'canonical_uri is not nil' do
      context 'there is a canonical with the given slug' do
        let!(:permalink_to_canonize) do
          create(:permalink)
        end
        let!(:canonical_uri) do
          create(:canonical_uri, slug: permalink_to_canonize.slug)
        end
        it 'should create a new permalink without errors' do
          permalink = FactoryBot.build(:permalink,
                                       canonical_uri: canonical_uri.slug)
          expect { permalink.save! }.to change(Permalink, :count).by(1)
        end
      end

      context 'a canonical with the canonica_uri does not exist' do
        it 'should raise an error' do
          permalink = FactoryBot.build(:permalink,
                                       canonical_uri: 'nonexistent')
          expect { permalink.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  context 'on update' do
    let(:permalink) { create(:permalink) }
    it 'updates related search data' do
      search_data = create(:search_datum, permalink: permalink)
      permalink.update(slug: 'another-slug')

      search_data.reload
      expect(search_data.permalink_slug).to eq('another-slug')
    end
  end

  context 'on create' do
    it 'creates related search data' do
      expect do
        complete_permalink
      end.to change(SearchDatum, :count).by(1)
    end

    context 'created search datum' do
      let!(:node) { create(:node, active: true) }
      let!(:item) { create(:item, active: true) }
      let!(:node_module) { create(:node_module, active: true) }

      context 'permalink ends with node' do
        let!(:permalink) { create(:permalink, nodes: [node]) }

        it 'has the same node as permalink' do
          expect(SearchDatum.last.node_id).to eq(permalink.nodes.last.id)
        end

        it 'has no node module' do
          expect(SearchDatum.last.node_module_id).to be_nil
        end

        it 'has no item' do
          expect(SearchDatum.last.item_id).to be_nil
        end

        it 'has the node attributes' do
          assert_attributes_for(name: node.name,
                                entity_type: node.node_type,
                                description: node.description,
                                free: false,
                                entity: 'node')
        end
      end

      context 'permalink ends with node module' do
        let!(:permalink) do
          create(:permalink, nodes: [node],
                             node_module: node_module)
        end

        it 'has the same node as permalink' do
          expect(SearchDatum.last.node_id).to eq(permalink.nodes.last.id)
        end

        it 'has the same node module as permalink' do
          expect(
            SearchDatum.last.node_module_id
          ).to eq(permalink.node_module_id)
        end

        it 'has no item' do
          expect(SearchDatum.last.item_id).to eq(nil)
        end

        it 'has the node module attributes' do
          assert_attributes_for(name: node_module.name,
                                entity_type: 'node_module',
                                description: node_module.description,
                                free: false,
                                entity: 'node_module')
        end
      end

      context 'permalink ends with item' do
        let!(:permalink) do
          node_module.items = [item]
          node_module.save
          create(:permalink,
                 nodes: [node],
                 node_module: node_module,
                 item: item)
        end

        it 'has the same node as permalink' do
          expect(SearchDatum.last.node_id).to eq(permalink.nodes.last.id)
        end

        it 'has the same item as permalink' do
          expect(SearchDatum.last.item_id).to eq(permalink.item_id)
        end

        it 'has the same node module as permalink' do
          expect(
            SearchDatum.last.node_module_id
          ).to eq(permalink.node_module_id)
        end

        it 'has the item attributes' do
          assert_attributes_for(name: item.name,
                                entity_type: item.item_type,
                                description: item.description,
                                free: item.free,
                                entity: 'item')
        end
      end
    end
  end

  describe '#active' do
    context 'all entities are active' do
      it 'returns true' do
        permalink = complete_permalink
        expect(permalink.active).to eq(true)
      end
    end

    context 'any entity is inactive' do
      it 'returns false' do
        permalink = create(:permalink)
        create(:node, active: false, permalink_ids: [permalink.id])
        permalink.reload
        expect(permalink.active).to eq(false)
      end
    end
  end

  context '#find_by_slug_with_ordered_entities' do
    context 'when permalink has inactive entities' do
      it 'returns the permalink' do
        permalink = create(:permalink, slug: 'inactive-node/slug')
        create(:node, active: false, permalink_ids: [permalink.id])

        expect(
          Permalink.find_by_slug_with_ordered_entities(permalink.slug)
        ).to eq(permalink)
      end
    end
  end

  context '#find_by_slug_with_active_entities' do
    context 'when permalink does not exist' do
      it 'returns nil' do
        create(:permalink, slug: 'another/slug')
        permalink = create(:permalink)
        permalink.delete
        expect(
          Permalink.find_by_slug_with_active_entities(permalink.slug)
        ).to eq(nil)
      end
    end

    context 'when permalink has an inactive node' do
      it 'returns nil' do
        permalink = create(:permalink, slug: 'inactive-node/slug')
        create(:node, active: false, permalink_ids: [permalink.id])

        expect(
          Permalink.find_by_slug_with_active_entities(permalink.slug)
        ).to eq(nil)
      end
    end

    context 'when permalink has an inactive node_module' do
      before do
        @permalink = complete_permalink
        @permalink.node_module.active = false
        @permalink.node_module.save
        @permalink.reload
      end
      it 'returns nil' do
        expect(
          Permalink.find_by_slug_with_active_entities(@permalink.slug)
        ).to eq(nil)
      end
    end
  end

  context '.entities' do
    context 'has no entities' do
      it 'returns entities as an empty array' do
        permalink = create(:permalink)
        expect(permalink.entities).to be_empty
      end
    end

    context 'has inactive entities' do
      before do
        @permalink = complete_permalink
        @permalink.node_module.active = false
        @permalink.node_module.save
        @permalink.reload
      end
      it 'returns entities as an empty array' do
        expect(@permalink.entities).to eq([])
      end
    end

    context 'has entities' do
      context 'with active entities' do
        it 'returns all as entities' do
          permalink = complete_permalink

          entities = [
            { id: permalink.nodes.first.id,
              name: permalink.nodes.first.name,
              color_hex: permalink.nodes.first.color_hex,
              slug: permalink.nodes.first.slug,
              entity_type: 'node',
              node_type: 'education_segment' },
            { id: permalink.node_module.id,
              name: permalink.node_module.name,
              slug: permalink.node_module.slug,
              entity_type: 'node_module' },
            { id: permalink.item.id,
              name: permalink.item.name,
              slug: permalink.item.slug,
              entity_type: 'item' }
          ]
          expect(permalink.entities).to eq entities
          expect(
            Permalink.find_by_slug_with_ordered_entities(permalink.slug)
                     .entities
          ).to eq(entities)
        end
      end
    end
  end

  context 'children has medium' do
    let(:refresh_materialized_view) do
      MeSalva::Postgres::MaterializedViews.new.refresh
    end
    it 'returns medium count by medium_type' do
      entities = node_to_medium_structure
      medium_count = Random.new.rand(10)
      add_media_to_item(entities[:item].id, medium_count)
      refresh_materialized_view

      media_length = (medium_count + 1) * 15

      expect(entities[:node].medium_count['video']).to eq medium_count + 1
      expect(entities[:node_module]
        .medium_count['video']).to eq medium_count + 1
      expect(entities[:item].seconds_duration).to eq media_length
      types = Medium::ALLOWED_TYPES - ['video']
      types.each do |type|
        expect(entities[:node].medium_count[type]).to eq 0
        expect(entities[:node_module].medium_count[type]).to eq 0
        expect(entities[:item].medium_count[type]).to eq 0
      end
    end
    it 'counts each medium_type separately' do
      entities = node_to_medium_structure
      entities[:medium].destroy
      @counter = {}

      Medium::ALLOWED_TYPES.each do |type|
        @counter[type] = Random.new.rand(10)
        add_media_to_item(entities[:item].id, @counter[type], type)
      end

      refresh_materialized_view

      Medium::ALLOWED_TYPES.each do |type|
        expect(entities[:node].medium_count[type]).to eq @counter[type]
        expect(entities[:node_module].medium_count[type]).to eq @counter[type]
        expect(entities[:item].medium_count[type]).to eq @counter[type]
      end
      expect(entities[:item].seconds_duration).to eq @counter['video'] * 15
    end

    it 'counts media for all child nodes' do
      @counter = {}
      grand_parent = create(:node, name: 'grand_parent')
      parent = create(:node, parent: grand_parent, name: 'parent')

      entities = node_to_medium_structure
      entities[:medium].destroy
      child_node = Node.find(entities[:node].id)
      child_node.parent = parent
      child_node.save
      entities[:node].reload

      [entities[:node], parent, grand_parent].each do |node|
        @counter[node.slug] = {}
        Medium::ALLOWED_TYPES.each do |type|
          @counter[node.slug][type] = Random.new.rand(10)
          add_node_module_with_media_to_node(node,
                                             @counter[node.slug][type], type)
        end
      end

      refresh_materialized_view

      Medium::ALLOWED_TYPES.each do |type|
        expect(entities[:node].medium_count[type])
          .to eq @counter[entities[:node].slug][type]

        expect(parent.medium_count[type])
          .to eq @counter[entities[:node].slug][type] +
                 @counter[parent.slug][type]

        expect(grand_parent.medium_count[type])
          .to eq @counter[entities[:node].slug][type] +
                 @counter[parent.slug][type] +
                 @counter[grand_parent.slug][type]
      end
    end
  end

  context 'updating node' do
    context 'node is part of permalinks' do
      before :each do
        Node.destroy_all
        Permalink.destroy_all

        segment = create(:node)
        @node = create(:node_area,
                       parent_id: segment.id, color_hex: 'black')
        child_node = create(:node_subject, parent_id: @node.id)
        create(:node_module, node_ids: [child_node.id])
      end
      it 'does not update slug' do
        node_slug = @node.slug
        @node.name = 'name'
        @node.save!
        @node.reload
        expect(@node.slug).to eq node_slug
      end
    end
  end

  def complete_permalink
    node = create(:node)
    node_module = create(:node_module, nodes: [node])
    item = create(:item, node_modules: [node_module])
    create(:permalink, slug: 'slug', nodes: [node],
                       node_module: node_module, item: item)
  end

  # rubocop:disable Metrics/AbcSize
  def assert_attributes_for(**attr)
    last_data = SearchDatum.last
    expect(last_data.name).to eq(attr[:name])
    expect(last_data.entity_type).to eq(attr[:entity_type])
    expect(last_data.description).to eq(attr[:description])
    expect(last_data.free).to eq(attr[:free])
    expect(last_data.entity).to eq(attr[:entity])
  end
  # rubocop:enable Metrics/AbcSize
end
