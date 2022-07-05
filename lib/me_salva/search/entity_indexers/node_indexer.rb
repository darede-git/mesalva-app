# frozen_string_literal: true

require 'me_salva/search/entity_indexers/base_entity_indexer'

module MeSalva
  module Search
    class NodeIndexer < BaseEntityIndexer
      def params_for_update
        {
          description: @entity.description,
          name: @entity.name,
          entity_type: @entity.node_type,
          entity: 'node',
          attachment: @entity.image.serializable_hash[:url],
          popularity: 1000,
          free: false,
          node_id: @entity.id
        }
      end
    end
  end
end
