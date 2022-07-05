# frozen_string_literal: true

require 'me_salva/search/entity_indexers/item_indexer'
require 'spec_helper'

describe MeSalva::Search::ItemIndexer do
  let(:item) { create(:item) }

  describe '#params_for_update' do
    describe 'returned hash' do
      subject do
        MeSalva::Search::ItemIndexer
          .new(item)
          .params_for_update
      end

      it 'has the item description' do
        expect(subject[:description]).to eq(item.description)
      end

      it 'has the item name' do
        expect(subject[:name]).to eq(item.name)
      end

      it 'has "entity" set to "item"' do
        expect(subject[:entity]).to eq('item')
      end

      it 'has "entity_type" set to the item\'s "node_type"' do
        expect(subject[:entity_type]).to eq(item.item_type)
      end

      it 'has "attachment" set to Me Salva\'s CDN link to the item\'s image' do
        expect(subject[:attachment]).to eq('')
      end

      it 'has "popularity" set to 10' do
        expect(subject[:popularity]).to eq(10)
      end
    end
  end
end
