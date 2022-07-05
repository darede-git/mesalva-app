# frozen_string_literal: true

module MeSalva
  module Permalinks
    class Access
      def initialize(attrs = {})
        @user = attrs[:user]
        @permalink = attrs[:permalink]
      end

      def children
        children = permalink_children.active.listed

        return [] if children.empty?

        children.each_with_object([]) do |entity, list|
          list.push(children_hash(entity))
        end
      end

      def children_hash(entity)
        { 'permalink-slug' => entity.slug,
          'status-code' => status_code_for(entity.ancestor_ids << entity.id) }
      end

      def validate(node_ids, user)
        user_nodes = purchased_nodes(user)
        return false unless user_nodes.any?

        (user_nodes & node_ids).any?
      end

      def permalink_children
        last_node.children
      end

      def permalink_slug
        @permalink.slug
      end

      def status_code
        return 200 if (purchased_nodes(@user) & @permalink.node_ids).any?

        402
      end

      def status_code_for(entity)
        return 200 if validate(entity, @user)

        402
      end

      private

      def purchased_nodes(user)
        access_in_range = ::Access.by_user_active_in_range(user)
        @purchased_nodes ||= access_in_range.map(&:package)
                                            .map(&:node_ids)
                                            .flatten
      end

      def last_node
        @permalink.nodes.last
      end
    end
  end
end
