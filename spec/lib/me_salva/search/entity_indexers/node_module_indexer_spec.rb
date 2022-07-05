# frozen_string_literal: true

require 'me_salva/search/entity_indexers/node_module_indexer'
require 'spec_helper'

describe MeSalva::Search::NodeModuleIndexer do
  let(:node_module) { create(:node_module) }

  describe '#params_for_update' do
    describe 'returned hash' do
      subject do
        MeSalva::Search::NodeModuleIndexer
          .new(node_module)
          .params_for_update
      end

      it 'has the node_module description' do
        expect(subject[:description]).to eq(node_module.description)
      end

      it 'has the node_module name' do
        expect(subject[:name]).to eq(node_module.name)
      end

      it 'has "entity" set to "node_module"' do
        expect(subject[:entity]).to eq('node_module')
      end

      it 'has "entity_type" set to the node_module\'s "node_type"' do
        expect(subject[:entity_type]).to eq('node_module')
      end

      it 'has "attachment" set to node_module\'s image url' do
        expect(
          subject[:attachment]
        ).to eq(node_module.image.serializable_hash[:url])
      end

      it 'has "popularity" set to 100' do
        expect(subject[:popularity]).to eq(100)
      end
    end
  end
end
