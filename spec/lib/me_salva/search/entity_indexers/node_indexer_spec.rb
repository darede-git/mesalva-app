# frozen_string_literal: true

require 'me_salva/search/entity_indexers/node_indexer'
require 'spec_helper'

describe MeSalva::Search::NodeIndexer do
  let(:node) { create(:node) }

  describe '#params_for_update' do
    describe 'returned hash' do
      subject do
        MeSalva::Search::NodeIndexer
          .new(node)
          .params_for_update
      end

      it 'has the node description' do
        expect(subject[:description]).to eq(node.description)
      end

      it 'has the node name' do
        expect(subject[:name]).to eq(node.name)
      end

      it 'has "entity" set to "node"' do
        expect(subject[:entity]).to eq('node')
      end

      it 'has "entity_type" set to the node\'s "node_type"' do
        expect(subject[:entity_type]).to eq(node.node_type)
      end

      it 'has "attachment" set the node\`s image url' do
        expect(subject[:attachment]).to eq(node.image.serializable_hash[:url])
      end

      it 'has "popularity" set to 1000' do
        expect(subject[:popularity]).to eq(1000)
      end
    end
  end
end
