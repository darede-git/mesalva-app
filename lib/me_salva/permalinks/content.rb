# frozen_string_literal: true

module MeSalva
  module Permalinks
    class Content
      def initialize(slug, namespace = 'Content')
        @namespace = namespace
        @slug = slug
      end

      def entities
        @entities ||= serialized_entities
      end

      def permalink
        @permalink ||= ::Permalink.find_by_slug_with_active_entities(@slug)
      end

      def serializable_hash_for(obj, **options)
        @obj = obj
        namespace_serializable_class
          .new(entity, options)
          .to_hash
      end

      private

      def serialized_entities
        return if active_entities.empty?

        return serialize_and_merge_last_item if medium_permalink?

        serialize_last_entity
      end

      def serialize_and_merge_last_item
        @active_entities[-2] = parsed_item
        active_entities
      end

      def active_entities
        @active_entities ||= permalink.entities
      end

      def medium_permalink?
        permalink.medium_id.present?
      end

      def serialize_last_entity
        @active_entities[-1] = serializable_hash_for(last_entity)
        active_entities
      end

      def last_entity
        active_entities.last
      end

      def entity
        return find_entity_for(@obj) if @obj.is_a?(Hash)

        @obj
      end

      def find_entity_for(hash)
        hash[:entity_type].camelize.constantize.find(hash[:id])
      end

      def serializable_class
        entity.class
      end

      def parsed_item
        namespace_serializable_class('Item').new(permalink.item).as_json
      end

      def namespace_serializable_class(entity_name = serializable_class)
        "::#{@namespace}::#{entity_name}Serializer".constantize
      end
    end
  end
end
