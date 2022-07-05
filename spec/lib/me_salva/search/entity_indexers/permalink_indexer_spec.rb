# frozen_string_literal: true

require 'me_salva/search/entity_indexers/permalink_indexer'
require 'me_salva/search/entity_indexers/item_indexer'

require 'spec_helper'

RSpec.shared_examples 'a permalink search data hash' do
  it 'has the permalink slug' do
    expect(subject[:permalink_slug]).to eq(permalink.slug)
  end

  it 'has the permalink\'s education_segment slug' do
    first_slug = permalink.slug.split('/').first
    expect(subject[:education_segment]).to eq(first_slug)
  end

  it 'has the second level (and on) slugs' do
    slugs = permalink.slug.split('/')
    second_level_slugs = slugs[1..-1].join('/')
    expect(subject[:second_level_slug]).to eq(second_level_slugs)
  end

  it 'has the permalink\'s link to mesalva.com' do
    expect(subject[:link]).to eq("https://www.mesalva.com/#{permalink.slug}")
  end
end

describe MeSalva::Search::PermalinkIndexer do
  let(:permalink) { create(:permalink) }
  let(:node) { create(:node, permalink_ids: [permalink.id]) }
  let(:node_module) { create(:node_module) }
  let(:item) { create(:item) }

  before do
    node_module.items = [item]
    permalink.nodes = [node]
    permalink.node_module_id = node_module.id
    permalink.item_id = item.id
    permalink.save
    permalink.reload
  end

  describe '#params_for_update' do
    describe 'returned hash' do
      subject do
        MeSalva::Search::PermalinkIndexer
          .new(permalink)
          .params_for_update
      end

      it_behaves_like 'a permalink search data hash'
    end
  end

  describe '#params_for_create' do
    subject do
      MeSalva::Search::PermalinkIndexer
        .new(permalink, [])
        .params_for_create
    end

    it_behaves_like 'a permalink search data hash'

    context 'entity specific attributes' do
      context 'permalink ends with item' do
        it 'should be gotten from the item indexer' do
          item_attributes = MeSalva::Search::ItemIndexer.new(
            item
          ).params_for_update

          item_attributes.each do |k, v|
            expect(v).to eq(subject[k])
          end
        end
      end

      context 'permalink ends with node module' do
        before do
          permalink.item_id = nil
          permalink.save
          permalink.reload
        end

        it 'should be gotten from the node module indexer' do
          node_module_attributes = MeSalva::Search::NodeModuleIndexer.new(
            node_module
          ).params_for_update

          node_module_attributes.each do |k, v|
            expect(v).to eq(subject[k])
          end
        end
      end

      context 'permalink ends with node' do
        before do
          permalink.item_id = nil
          permalink.node_module_id = nil
          permalink.save
          permalink.reload
        end
        it 'should be gotten from the node indexer' do
          node_attributes = MeSalva::Search::NodeIndexer.new(
            node
          ).params_for_update

          node_attributes.each do |k, v|
            expect(v).to eq(subject[k])
          end
        end
      end

      context 'permalink is empty' do
        let(:permalink) { create(:permalink) }

        it_behaves_like 'a permalink search data hash'
      end
    end
  end
end
