# frozen_string_literal: true

require 'me_salva/search/entity_indexers/base_entity_indexer'

module MeSalva
  module Search
    class NodeModuleIndexer < BaseEntityIndexer
      def params_for_update
        {
          description: @entity.description,
          name: @entity.name,
          entity_type: 'node_module',
          entity: 'node_module',
          attachment: @entity.image.serializable_hash[:url],
          popularity: 100,
          free: false,
          node_module_id: @entity.id
        }
      end
    end
  end
end
