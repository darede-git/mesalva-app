# frozen_string_literal: true

module MeSalva
  module Permalinks
    class BrokenPermalinkFixer
      def initialize(entity)
        @entity = entity
      end

      def rebuild
        rebuild_node if @entity.instance_of?(Node)
        rebuild_node_module if @entity.instance_of?(NodeModule)
        rebuild_item if @entity.instance_of?(Item)
      end

      def self.fix_module_by_permalink_slug(permalink_slug)
        permalink_slug = remove_domain_from_permalink(permalink_slug)
        permalink = Permalink.find_by_slug(permalink_slug)
        return nil if permalink.node_module_id.nil?

        permalink.node_module.rebuild_permalink
      end

      def self.fix_item_by_permalink_slug(item_permalink_slug)
        item_permalink_slug = remove_domain_from_permalink(item_permalink_slug)
        permalink = Permalink.find_by_slug(item_permalink_slug)
        return rebuild_item_parent_by_slug(item_permalink_slug) if permalink.nil?
        unless permalink.item_id.nil? || permalink.node_module_id.nil?
          return permalink.item.rebuild_permalink
        end

        permalink.item.media { |m| m.update(listed: true) }
        permalink.delete
        rebuild_item_parent_by_slug(item_permalink_slug)
      end

      def self.rebuild_item_parent_by_slug(item_permalink_slug)
        # TODO: encontrar o item pelo slug e rodar o rebuild normal
        item_permalink_slug_array = item_permalink_slug.split('/')
        item_permalink_slug_array.pop
        node_module_permalink_slug = item_permalink_slug_array.join('/')
        Permalink.find_by_slug(node_module_permalink_slug)
                 .node_module
                 .rebuild_permalink
      end

      def rebuild_specific_item(parent_permalink, node_ids, node_module_id)
        current_permalink = "#{parent_permalink}/#{@entity.slug}"

        unless Permalink.where(slug: current_permalink).count.positive?
          Permalink.create(slug: current_permalink,
                           node_ids: node_ids,
                           node_module_id: node_module_id,
                           item_id: @entity.id)
        end

        @entity.media.map do |medium|
          self.class.new(medium).rebuild_specific_medium(current_permalink,
                                                         node_ids,
                                                         node_module_id, @entity.id)
        end
      end

      def rebuild_specific_medium(parent_permalink, node_ids, node_module_id, item_id)
        current_permalink = "#{parent_permalink}/#{@entity.slug}"
        return if Permalink.where(slug: current_permalink).count.positive?

        Permalink.create(slug: current_permalink, node_ids: node_ids,
                         node_module_id: node_module_id, item_id: item_id,
                         medium_id: @entity.id)
      end

      def self.remove_domain_from_permalink(url)
        url.gsub(%r{(http|https)://(www|qa)\.mesalva\.com/(.*)}, '\3')
      end

      private

      def rebuild_item
        Permalink.where(item_id: @entity.id).delete_all
        @entity.node_module_ids.each do |node_module_id|
          node_module_permalinks = Permalink.where('node_module_id = ? AND item_id IS NULL', [node_module_id])
          node_module_permalinks.each do |node_module_permalink|
            item_permalink = Permalink.create(node_ids: node_module_permalink.node_ids, node_module_id: node_module_id, item_id: @entity.id, slug: "#{node_module_permalink.slug}/#{@entity.slug}")
            media = @entity.media
            media.map do |medium|
              medium.update(listed: true)
              medium_permalink = Permalink.create(node_ids: node_module_permalink.node_ids, node_module_id: node_module_id, item_id: @entity.id, medium_id: medium.id, slug: "#{item_permalink.slug}/#{medium.slug}", permalink_id: node_module_permalink.id)
              if medium_permalink.errors
                medium_permalink = Permalink.find_by_slug("#{item_permalink.slug}/#{medium.slug}")
                medium_permalink.update(node_ids: node_module_permalink.node_ids, node_module_id: node_module_id, item_id: @entity.id, medium_id: medium.id, permalink_id: item_permalink.id)
              end
            end
          end
        end
      end

      # rubocop:disable Metrics/AbcSize
      def rebuild_node
        parent_node_ids = @entity.ancestry.split('/').reject { |id| id == '1' }
        @parent_nodes = parent_node_ids.map { |id| Node.find(id) }

        @nodes = @parent_nodes.clone
        @nodes << @entity

        node_ids = @nodes.pluck(:id)

        current_permalink = @nodes.pluck(:slug).join('/')

        unless Permalink.where(slug: current_permalink).count.positive?
          Permalink.create(slug: current_permalink, node_ids: node_ids)
        end

        @entity.children.map { |n| self.class.new(n).rebuild }
        @entity.node_modules.map { |nm| self.class.new(nm).rebuild }
      end

      def rebuild_item_media(item)
        Permalink.where("item_id = ? AND medium_id IS NULL", [item.id]).delete_all
        media = item.media
        Permalink.where(item_id: item.id).each do |permalink|
          media.each do |medium|
            Permalink.create(node_ids: permalink.node_ids, item_id: permalink.item_id,
                             medium_id: medium.id, slug: "#{permalink.slug}/#{medium.slug}")
          end
        end
      end

      def rebuild_node_module
        @direct_parent_nodes = @entity.nodes

        Permalink.where(node_module_id: @entity.id).delete_all

        @direct_parent_nodes.each do |parent_node|
          next if parent_node.ancestry.nil?

          parent_node_ids = parent_node.ancestry.split('/').reject { |id| id == '1' }
          nodes_to_permalink_nodes = parent_node_ids.map { |id| Node.find(id) }
          nodes_to_permalink_nodes << parent_node

          node_ids = nodes_to_permalink_nodes.pluck(:id)
          parent_permalink = nodes_to_permalink_nodes.pluck(:slug).join('/')

          current_permalink = "#{parent_permalink}/#{@entity.slug}"

          unless Permalink.where(slug: current_permalink).count.positive?
            Permalink.create(slug: current_permalink, node_ids: node_ids,
                             node_module_id: @entity.id)
          end

          @entity.items.map do |item|
            self.class.new(item).rebuild_specific_item(current_permalink, node_ids, @entity.id)
          end
        end
      end

      # rubocop:enable Metrics/AbcSize
    end
  end
end
