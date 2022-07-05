# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.describe NodeModule, type: :model do
  include SlugAssertionHelper
  include RelationshipOrderAssertionHelper
  include ContentStructureCreationHelper

  it_should_behave_like 'a searchable entity', NodeModule
  it_should_behave_like 'an entity with meta tags', NodeModule

  context 'validations' do
    should_be_present(:name, :slug, :node_module_type)
    should_have_many(:permalinks, :items, :media, :nodes)
    it do
      should validate_inclusion_of(:node_module_type)
        .in_array(%w[default prep_test prep_test_tri prep_test_b2b])
    end
  end

  context 'scopes' do
    context '.active' do
      it 'returns only the active nodes' do
        assert_valid('node_module')
      end
    end
    context '.with_medium_counters_by_id' do
      let(:node_module_ids) do
        create_list(:node_module, 5).map(&:id)
      end
      before do
        node_module_ids.each do |nm_id|
          create(:medium, items: [
                   create(:item, node_module_ids: [nm_id])
                 ])
        end
      end
      it 'returns node module id and counters' do
        counters = NodeModule
                   .with_medium_counters_by_id(node_module_ids.first(3))
        expect(counters).to eq(
          [{ "id" => node_module_ids[0], "counters" => { "video" => "1" } },
           { "id" => node_module_ids[1], "counters" => { "video" => "1" } },
           { "id" => node_module_ids[2], "counters" => { "video" => "1" } }]
        )
      end
    end
  end

  context 'on save' do
    it 'should create slug' do
      node_module = create(:node_module)
      expect(node_module.slug).not_to be nil
      expect(node_module.slug).to eq node_module.name.tr('_', '-')
    end
  end

  context 'node_module has many items' do
    it 'orders items by position' do
      assert_relationship_id_ordering(:node_module, :item)
    end
    it "counts only related item's media" do
      node_module = create(:node_module)
      items = create_list(:item, 5)
      node_module.item_ids = [items.first.id]
      items.each do |i|
        i.medium_ids = create_list(:medium, 5).map(&:id)
      end
      expect(node_module.medium_count['video']).to eq 5
    end
  end

  context 'node_module has many nodes' do
    context 'permalinks exists' do
      before do
        @entities = node_to_many_node_modules
      end
      context 'removing node from node_module' do
        it 'removes related node permalinks' do
          expect do
            @entities[:node_modules].last.node_ids = []
          end.to change(Permalink, :count).by(-1)
          expect(@entities[:node_modules].last.permalinks).to be_empty
          expect(@entities[:child_node].permalinks.pluck(:node_module_id))
            .not_to include @entities[:node_modules].last.id
        end
        context 'node_module has many parents' do
          before do
            @node2 = fill_node_module_tree(@entities[:node_modules].last,
                                           @entities[:node])
          end
          it 'removes only permalinks related with removed node' do
            expect do
              @entities[:node_modules].last.node_ids = [@node2.id]
            end.to change(Permalink, :count).by(-3)
            expect(@entities[:node_modules].last.permalinks.count).to eq 3

            expect(@entities[:node_modules].last.permalinks.order(:id).last)
              .to eq @node2.permalinks.order(:id).last

            @entities[:node_modules].last.permalinks.each do |permalink|
              expect(@entities[:child_node].permalinks.pluck(:slug))
                .not_to include permalink.slug
            end
          end
        end
      end
    end
  end
end
