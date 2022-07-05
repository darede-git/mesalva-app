# frozen_string_literal: true

require 'me_salva/search/entity_indexers/base_entity_indexer'

module MeSalva
  module Search
    class ItemIndexer < BaseEntityIndexer
      def params_for_update
        {
          description: @entity.description,
          name: @entity.name,
          entity_type: @entity.item_type,
          entity: 'item',
          attachment: '',
          popularity: 10,
          free: @entity.free,
          item_id: @entity.id
        }
      end
    end
  end
end
