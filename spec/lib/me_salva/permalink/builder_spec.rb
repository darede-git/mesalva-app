# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.shared_examples 'a first permalink' do |node_types|
  node_types.each do |node_type|
    context "first entity node_type is #{node_type}" do
      it 'builds first permalink' do
        node = create(:node, node_type: node_type)
        expect do
          build_permalinks(node, :subtree)
        end.to change(Permalink, :count).by(1)
      end
    end
  end
end

describe MeSalva::Permalinks::Builder do
  include PermalinkAssertionHelper
  include PermalinkBuildingHelper

  let(:node_module) { create(:node_module) }
  let(:item) { create(:item) }
  let(:medium) { create(:medium) }

  let(:node) { create(:node) }
  let(:node_area) { create(:node_area, parent: node) }
  let(:node_subject) { create(:node_subject, parent: node_area) }
  let(:node_module_inactivable) do
    create(:node_module, nodes: [node_subject])
  end
  let(:item_inactivable) do
    create(:item, node_modules: [node_module_inactivable])
  end
  let!(:medium_inactivable) do
    create(:medium, items: [item_inactivable])
  end

  describe 'permalink building' do
    context 'from node to medium' do
      it 'sets previous permalink as parent permalink' do
        node = create(:node)
        node_area = create(:node_area, parent: node)
        node_module.nodes = [node_area]
        item.node_modules = [node_module]
        medium.items = [item]
        build_permalinks(node, :subtree)

        expect(medium.permalinks.pluck(:permalink_id)).not_to include nil
        expect(item.permalinks.pluck(:permalink_id)).not_to include nil
        expect(node_module.permalinks.pluck(:permalink_id)).not_to include nil
        expect(node_area.permalinks.pluck(:permalink_id)).not_to include nil
        expect(node.permalinks.order(:id).first.permalink_id).to eq nil

        expect(medium.permalinks.order(:id).first.permalink_id)
          .to eq(item.permalinks.order(:id).first.id)
        expect(medium.permalinks.order(:id).first.permalink_id)
          .to eq(item.permalinks.order(:id).last.permalink_id)
        expect(medium.permalinks.order(:id).first.permalink_id)
          .to eq(node_module.permalinks.order(:id).last.permalink_id)
        expect(medium.permalinks.order(:id).first.permalink_id)
          .to eq(node_area.permalinks.order(:id).last.permalink_id)
        expect(medium.permalinks.order(:id).first.permalink_id)
          .to eq(node.permalinks.order(:id).last.permalink_id)

        expect(item.permalinks.order(:id).first.permalink_id)
          .to eq(node_module.permalinks.order(:id).first.id)
        expect(item.permalinks.order(:id).first.permalink_id)
          .to eq(node_area.permalinks.order(:id).second.id)
        expect(item.permalinks.order(:id).first.permalink_id)
          .to eq(node.permalinks.order(:id).third.id)

        expect(node_module.permalinks.order(:id).first.permalink_id)
          .to eq(node_area.permalinks.order(:id).first.id)
        expect(node_module.permalinks.order(:id).first.permalink_id)
          .to eq(node.permalinks.order(:id).second.id)

        expect(node_area.permalinks.order(:id).first.permalink_id)
          .to eq(node.permalinks.order(:id).first.id)
      end
    end
    context 'node_module has multiple parent nodes' do
      it 'should add a permalink from the last node_module permalink' do
        entities = parents_for(node_module)
        entities2 = parents_for(node_module)
        build_permalinks(entities[:node].parent, :subtree)
        build_permalinks(entities2[:node].parent, :subtree)

        expect do
          node_module.item_ids = [item.id]
          build_permalinks(node_module, :children)
        end.to change(Permalink, :count).by(2)

        top_slug = entities[:education_segment].slug
        item_first_permalink = item.permalinks
                                   .where("slug like '#{top_slug}/%'").first

        item_last_permalink = item.permalinks
                                  .where('slug not like '\
        "'#{entities[:education_segment].slug}/%'").first

        [[item_first_permalink, entities], [item_last_permalink, entities2]]
          .each do |i|
          assert_permalink_inclusion(i[0], [
                                       i[1][:education_segment].permalinks,
                                       i[1][:node].permalinks,
                                       node_module.permalinks
                                     ])
          assert_permalink_entities_inclusion(
            i[0],
            node: [i[1][:education_segment].id, i[1][:node].id],
            node_module: node_module.id,
            item: item.id,
            medium: nil
          )
          expect(i[0].slug).to eq slug_for(
            [
              i[1][:education_segment],
              i[1][:node],
              node_module,
              item
            ]
          )
        end
      end
    end
    context 'item has multiple parents' do
      it 'should add a permalink from the last node_module permalink' do
        entities = parents_for(item)
        entities2 = parents_for(item)

        build_permalinks(entities[:node].parent, :subtree)
        build_permalinks(entities2[:node].parent, :subtree)

        expect do
          item.medium_ids = [medium.id]
          build_permalinks(item, :children)
        end.to change(Permalink, :count).by(2)

        medium_first_permalink = medium
                                 .permalinks
                                 .where(
                                   node_module_id: entities[:node_module].id
                                 ).first

        medium_last_permalink = medium
                                .permalinks
                                .where(node_module_id:
                                       entities2[:node_module].id).first

        [[medium_first_permalink, entities], [medium_last_permalink, entities2]]
          .each do |i|
          assert_permalink_inclusion(i[0], [
                                       i[1][:education_segment].permalinks,
                                       i[1][:node].permalinks,
                                       i[1][:node_module].permalinks,
                                       item.permalinks
                                     ])
          assert_permalink_entities_inclusion(
            i[0],
            node: [i[1][:education_segment].id, i[1][:node].id],
            node_module: i[1][:node_module].id,
            item: item.id,
            medium: medium.id
          )
          expect(i[0].slug).to eq slug_for(
            [
              i[1][:education_segment],
              i[1][:node],
              i[1][:node_module],
              item,
              medium
            ]
          )
        end
      end
    end
    context 'builds permalink from inactive entities' do
      it 'build permalinks with inactive node' do
        node_area.update(active: false)
        build_permalinks(node, :subtree)

        node_subject.permalinks.each do |permalink|
          expect(permalink.nodes.unscope(where: :active).pluck(:id))
            .to include(node_area.id)
        end
      end

      it 'builds permalinks with inactive node module' do
        node_module_inactivable.update(active: false)
        build_permalinks(node, :subtree)

        item_inactivable.permalinks.each do |permalink|
          expect(permalink.node_module_id).to eq(node_module_inactivable.id)
        end
      end

      it 'builds permalinks with inactive item' do
        item_inactivable.update(active: false)
        build_permalinks(node, :subtree)

        medium_inactivable.permalinks.each do |permalink|
          expect(permalink.item_id).to eq(item_inactivable.id)
        end

        expect(node_module_inactivable.permalinks)
          .to include(medium_inactivable.permalinks.first)
      end

      it 'builds permalinks with inactive medium' do
        medium_inactivable.update(active: false)
        build_permalinks(node, :subtree)

        expect(medium_inactivable.permalinks.first.medium_id)
          .to eq(medium_inactivable.id)
      end

      it 'builds permalinks from a node that is an inactive node child' do
        node_area.update(active: false)

        build_permalinks(node, :subtree)

        build_permalinks(node_subject, :subtree)

        node_subject.permalinks.each do |permalink|
          expect(node_area.permalinks).to include(permalink)
          expect(permalink.nodes.unscope(where: :active))
            .to include(node_area)
        end
      end

      it 'build permalinks from a node module that is an inactive node child' do
        node_subject.update(active: false)

        build_permalinks(node, :subtree)

        build_permalinks(node_module_inactivable, :subtree)

        node_module_inactivable.permalinks.each do |permalink|
          expect(node_subject.permalinks).to include(permalink)
          expect(permalink.node_module_id).to eq(node_module_inactivable.id)
        end
      end

      it 'build permalinks from a item that is an inactive node module child' do
        node_module_inactivable.update(active: false)

        build_permalinks(node, :subtree)

        build_permalinks(item_inactivable, :subtree)

        item_inactivable.permalinks.each do |permalink|
          expect(node_module_inactivable.permalinks).to include(permalink)
          expect(permalink.item_id).to eq(item_inactivable.id)
        end
      end

      it 'build permalinks from a medium that is an inactive item child' do
        item_inactivable.update(active: false)

        build_permalinks(node, :subtree)

        build_permalinks(medium_inactivable, :subtree)

        medium_inactivable.permalinks.each do |permalink|
          expect(item_inactivable.permalinks).to include(permalink)
          expect(permalink.medium_id).to eq(medium_inactivable.id)
        end
      end
    end

    it_behaves_like 'a first permalink', %w[education_segment
                                            live
                                            public_document]
  end
end
