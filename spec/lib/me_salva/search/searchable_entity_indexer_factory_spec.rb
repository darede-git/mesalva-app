# frozen_string_literal: true

require 'me_salva/search/searchable_entity_indexer_factory'
require 'spec_helper'

describe MeSalva::Search::SearchableEntityIndexer do
  describe '#for' do
    context 'entity is permalink' do
      let(:entity) { create(:permalink) }

      it 'returns a PermalinkIndexer' do
        expect(
          MeSalva::Search::SearchableEntityIndexer.for(entity)
        ).to be_instance_of(MeSalva::Search::PermalinkIndexer)
      end
    end

    context 'entity is node' do
      let(:entity) { create(:node) }

      it 'returns a NodeIndexer' do
        expect(
          MeSalva::Search::SearchableEntityIndexer.for(entity)
        ).to be_instance_of(MeSalva::Search::NodeIndexer)
      end
    end

    context 'entity is node_module' do
      let(:entity) { create(:node_module) }

      it 'returns a NodeModuleIndexer' do
        expect(
          MeSalva::Search::SearchableEntityIndexer.for(entity)
        ).to be_instance_of(MeSalva::Search::NodeModuleIndexer)
      end
    end

    context 'entity is item' do
      let(:entity) { create(:item) }

      it 'returns a ItemIndexer' do
        expect(
          MeSalva::Search::SearchableEntityIndexer.for(entity)
        ).to be_instance_of(MeSalva::Search::ItemIndexer)
      end
    end

    context 'entity is neither permalink nor node nor node_module nor item' do
      let(:entity) { create(:medium) }

      it 'raises an TypeError' do
        expect do
          MeSalva::Search::SearchableEntityIndexer.for(entity)
        end.to raise_error(TypeError)
      end
    end
  end
end
