# frozen_string_literal: true

module MeSalva
  module Permalinks
    class Builder
      include EntityTypeHelper
      include Common

      def initialize(attrs)
        @entity = attrs[:entity_class].constantize.find(attrs[:entity_id])
      end

      def build_subtree_permalinks
        build_first_permalink if first_permalink_type?
        build_self_permalinks unless parent_entities.empty?
        build_children_permalinks
      end

      def build_first_permalink
        return if @entity.permalinks.by_slug(@entity.slug).any?

        ::Permalink.create!(slug: @entity.slug, node_ids: [@entity.id])
      end

      def build_self_permalinks
        parent_entities.each do |parent_entity|
          entity_permalinks(parent_entity).each do |permalink|
            next if permalink_exists?("#{permalink.slug}/#{@entity.slug}",
                                      parent_entity.permalinks)

            create_permalink(
              slug: "#{permalink.slug}/#{@entity.slug}",
              permalink: permalink, entity: @entity
            )
          end
        end
      end

      def build_children_permalinks
        child_entities.each do |child_entity|
          entity_permalinks.each do |permalink|
            next if permalink_exists?("#{permalink.slug}/#{child_entity.slug}")

            create_permalink(slug: "#{permalink.slug}/#{child_entity.slug}",
                             permalink: permalink, entity: child_entity)
            recursive_child_permalink_build(child_entity)
          end
        end
      end

      private

      def recursive_child_permalink_build(child)
        Builder.new(entity_id: child.id, entity_class: child.class.to_s)
               .build_children_permalinks
      end

      def permalink_node_ids(permalink, entity = @entity)
        if node?(entity)
          return [unscoped_relationship_ids(permalink, "nodes"),
                  entity.id].flatten
        end
        unscoped_relationship_ids(permalink, "nodes")
      end

      def permalink_entity_id(permalink, entity_type, entity = @entity)
        return entity.id if public_send("#{entity_type}?", entity)

        permalink.public_send("#{entity_type}_id")
      end

      def permalink_exists?(new_permalink, permalinks = @entity.permalinks)
        permalinks.by_slug(new_permalink).any?
      end

      def first_permalink_type?
        %i[education_segment? live? public_document?].any? do |m|
          @entity.try(m)
        end
      end

      def create_permalink(**args)
        permalink = ::Permalink.create!(slug: args[:slug])
        permalink.node_ids = permalink_node_ids(args[:permalink], args[:entity])
        %w[node_module item medium].each do |entity_type|
          permalink.public_send(
            "#{entity_type}_id=",
            permalink_entity_id(args[:permalink], entity_type, args[:entity])
          )
        end
        permalink.permalink_id = args[:permalink].id
        permalink.save!
      end

      def child_entities
        return [] if medium?(@entity)

        return unscoped_relationship(@entity, "items") if node_module?(@entity)

        return unscoped_relationship(@entity, "media") if item?(@entity)

        node_child_entities if node?(@entity)
      end

      def node_child_entities
        return @entity.node_modules if @entity.node_modules.any?

        @entity.children
      end

      def parent_entities
        return unscoped_relationship(@entity, "nodes") if node_module?(@entity)
        return @entity.node_modules if item?(@entity)
        return @entity.items if medium?(@entity)

        node_parent
      end

      def node_parent
        [@entity.parent].compact
      end

      def unscoped_relationship(entity, relative)
        entity.public_send(relative).unscope(where: :active)
      end

      def unscoped_relationship_ids(entity, relative)
        unscoped_relationship(entity, relative).pluck(:id)
      end
    end
  end
end
