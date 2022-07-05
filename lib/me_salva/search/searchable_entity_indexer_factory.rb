# frozen_string_literal: true

require 'me_salva/search/entity_indexers/permalink_indexer'
require 'me_salva/search/entity_indexers/node_indexer'
require 'me_salva/search/entity_indexers/node_module_indexer'
require 'me_salva/search/entity_indexers/item_indexer'

module MeSalva
  module Search
    class SearchableEntityIndexer
      ENTITY_TYPES_INDEXERS = {
        permalink: MeSalva::Search::PermalinkIndexer,
        node: MeSalva::Search::NodeIndexer,
        node_module: MeSalva::Search::NodeModuleIndexer,
        item: MeSalva::Search::ItemIndexer
      }.freeze

      def self.for(entity, search_data = [])
        symbolized_entity_class_name = entity.class.name.underscore.to_sym
        indexer_class = ENTITY_TYPES_INDEXERS[symbolized_entity_class_name]
        invalid_entity_type unless indexer_class
        indexer_class.new(entity, search_data)
      end

      def self.invalid_entity_type
        raise TypeError,
              'Entity Class must be Searchable (either Permalink
              or Node or NodeModule or Item)'
      end
    end
  end
end
