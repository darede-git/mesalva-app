# frozen_string_literal: true

module MeSalva
  module Permalinks
    class Validator
      include EntityTypeHelper
      include Common

      def initialize(entity)
        @duplicated_permalinks = []
        @entity = entity
      end

      def duplicated_permalinks
        @duplicated_permalinks.flatten.map(&:slug)
      end

      def valid?
        public_send("validate_#{entity_class_name}")
        @duplicated_permalinks.empty?
      end

      def validate_item_medium
        self_entity_permalinks.each do |p|
          permalink = "#{p.slug}/#{@entity.medium.slug}".to_s
          find_duplicated_permalinks(permalink)
        end
      end

      def validate_node_module_item
        self_entity_permalinks.each do |p|
          permalink = "#{p.slug}/#{@entity.item.slug}".to_s
          find_duplicated_permalinks(permalink)
          find_child_duplicated_permalinks(permalink, entity_children)
        end
      end

      def validate_node_node_module
        filtered_node_permalinks(@entity.node).each do |p|
          permalink = "#{p.slug}/#{@entity.node_module.slug}".to_s
          find_duplicated_permalinks(permalink)
          find_child_duplicated_permalinks(permalink, entity_children)
        end
      end

      def validate_node
        return validate_node_node if should_validate_ancestry?

        permalinks = self_entity_permalinks
        @duplicated_permalinks << permalinks unless permalinks.empty?
      end

      def validate_node_node
        entity_permalinks(@entity.parent).each do |parent_permalink|
          new_permalink = "#{parent_permalink.slug}/#{@entity.slug}".to_s
          validate_node_children(new_permalink)
          filtered_node_permalinks(new_permalink).each do |permalink|
            @duplicated_permalinks << permalink
          end
        end
      end

      def validate_node_children(permalink)
        return if @entity.id.nil?

        find_child_duplicated_permalinks(permalink, @entity.children)
        find_child_duplicated_permalinks(permalink, @entity.node_modules)
      end

      def filtered_node_permalinks(search_criteria)
        return search_criteria.permalinks.node_permalinks if search_criteria.instance_of? Node

        ::Permalink.node_permalinks_by_slug(search_criteria)
      end

      def find_recursive_children_permalink(child_permalink, child)
        child_rels = { Item => [:media], NodeModule => [:items],
                       Node => %i[children node_modules] }
        child_rels[child.class].try(:each) do |rel|
          find_child_duplicated_permalinks(child_permalink,
                                           child.public_send(rel))
        end
      end

      def select_duplicated_child_permalinks(child_permalinks, child)
        child_permalinks.select do |permalink|
          if node?(child)
            permalink.node_ids.exclude? child.id
          else
            permalink.public_send("#{entity_class_name(child)}_id") != child.id
          end
        end
      end

      def find_child_duplicated_permalinks(permalink, children)
        children.each do |child|
          child_permalink = "#{permalink}/#{child.slug}".to_s
          child_permalinks = find_permalinks_by_slug(child_permalink)
          find_recursive_children_permalink(child_permalink, child)
          duplicated_permalinks =
            select_duplicated_child_permalinks(child_permalinks, child)
          next if duplicated_permalinks.empty?

          @duplicated_permalinks << child_permalinks
        end
      end

      def entity_children
        return @entity.item.media if node_module_item?(@entity)

        @entity.node_module.items if node_node_module?(@entity)
      end

      def find_duplicated_permalinks(target_permalink)
        child_id = child_entity_rel_name
        permalinks = ::Permalink.by_slug(target_permalink)
                                .where(
                                  "(#{child_id} != ? OR #{child_id} IS NULL)",
                                  @entity.public_send(child_id)
                                )
        @duplicated_permalinks << permalinks unless permalinks.empty?
      end

      def child_entity_rel_name
        return 'node_module_id' if node_node_module?(@entity)

        return 'item_id' if node_module_item?(@entity)

        'medium_id' if item_medium?(@entity)
      end

      def self_entity_permalinks
        if node_module_item?(@entity) || item_medium?(@entity)
          return find_permalink_ending_with(entity_slug)
        end
        return find_permalinks_by_slug(entity_slug) if new_entity?

        ::Permalink.with_permalink_nodes_by_slug(entity_slug)
                   .where('permalink_nodes.node_id != ?', @entity.id)
      end

      def entity_slug
        slugs = { ItemMedium => :item, NodeNodeModule => :node,
                  NodeModuleItem => :node_module }

        relation = slugs[@entity.class]
        return @entity.slug if relation.nil?

        @entity.public_send(relation).slug
      end

      def find_permalinks_by_slug(slug, include_nodes = true)
        if include_nodes
          ::Permalink.with_permalink_nodes_by_slug(slug)
        else
          ::Permalink.by_slug(slug)
        end
      end

      def find_permalink_ending_with(slug)
        ::Permalink.ending_with_slug(slug)
      end

      def new_entity?
        @entity.id.nil?
      end

      def entity_class_name(entity = @entity)
        entity.class.to_s.underscore
      end

      def should_validate_ancestry?
        @entity.ancestry.present? && @entity.ancestry_changed?
      end
    end
  end
end
