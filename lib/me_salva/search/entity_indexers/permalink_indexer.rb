# frozen_string_literal: true

require 'me_salva/search/entity_indexers/base_entity_indexer'
require 'me_salva/permalinks/content'
module MeSalva
  module Search
    class PermalinkIndexer < BaseEntityIndexer
      def create_search_data
        SearchDatum.create!(params_for_create)
      end

      def params_for_update
        permalink_params.merge(entities_params)
      end

      def params_for_create
        permalink_params.merge(entities_params)
      end

      private

      def permalink_params
        slugs = @entity.slug.split('/')
        {
          permalink_slug: @entity.slug,
          education_segment: slugs.shift,
          second_level_slug: slugs.join('/'),
          link: "#{ENV['DEFAULT_URL']}/#{@entity.slug}",
          permalink_id: @entity.id
        }
      end

      def entities_params
        @entity.entities.inject({}) do |memo, entity_hash|
          next memo if medium?(entity_hash)

          entity = get_entity_from_hash(entity_hash)
          entity_indexer = get_entity_indexer_for(entity)
          entity_params = entity_indexer.params_for_update
          memo.merge(entity_params)
        end || {}
      end

      def get_entity_indexer_for(entity)
        entity_class_name = entity.class.name
        entity_indexer =
          "MeSalva::Search::#{entity_class_name}Indexer".constantize
        entity_indexer.new(entity)
      end

      def get_entity_from_hash(hash)
        entity_class = hash[:entity_type].camelize.constantize
        entity_class.find(hash[:id])
      end

      def medium?(entity_hash)
        entity_hash[:entity_type] == 'medium'
      end
    end
  end
end
