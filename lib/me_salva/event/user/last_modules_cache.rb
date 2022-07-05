# frozen_string_literal: true

require 'me_salva/event/user/cache'
require 'me_salva/event/user/permalink_data'
require 'me_salva/event/user/consumed_media_cache'
require 'me_salva/event/user/consumed_modules_cache'

module MeSalva
  module Event
    module User
      class LastModulesCache < ActiveModelSerializers::Model
        attr_accessor :user_id, :permalink_id

        def update
          return false unless valid_permalink?

          true
        end

        def cache(node_slug = nil)
          return [] unless valid_caches?

          consumed_modules_cache.cache.each_with_object([]) do |m, last_modules|
            next if node_slug.present? && m["node_slug"] != node_slug

            medium_ids = consumed_media_cache_medium_ids(m)
            next if medium_ids.nil?

            last_module = merged_last_module(m, medium_ids)
            last_modules << last_module unless last_module[:'medium-count'].nil?
          end
        end

        def rebuild
          consumed_modules_cache.flush
          consumed_media_cache.flush
          consumed_modules_cache.build
          consumed_media_cache.build
        end

        private

        def consumed_media_cache_medium_ids(entities)
          consumed_media_cache
            .medium_ids(entities["node_slug"], entities["node_module_id"])
        end

        def merged_last_module(consumed_module, medium_ids)
          {
            "permalink": consumed_module['permalink'],
            "node": { "name": consumed_module['node'],
                      "slug": consumed_module['node_slug'] },
            "node-module": {
              "name": consumed_module['node_module'],
              "slug": consumed_module['node_module_slug']
            },
            "medium-count": medium_counters(medium_ids)
          }
        end

        def permalink
          @permalink ||= ::Permalink.find_by_id(permalink_id)
        end

        def valid_caches?
          return false if consumed_media_cache.cache.blank?

          return false if consumed_modules_cache.cache.blank?

          true
        end

        def valid_permalink?
          return false unless permalink.present?

          return false if permalink.nodes.empty? || permalink.slug.blank?

          %w[node_module item medium].all? do |entity|
            permalink.public_send(entity).present?
          end
        end

        def consumed_media_cache
          @consumed_media_cache ||= ConsumedMediaCache.new(
            user_id: user_id,
            permalink: permalink
          )
        end

        def consumed_modules_cache
          @consumed_modules_cache ||= ConsumedModulesCache.new(
            user_id: user_id,
            permalink: permalink
          )
        end

        def empty_user_consumed_media_cache?
          consumed_media_cache.cache.blank?
        end

        def empty_user_consumed_modules_cache?
          consumed_modules_cache.cache.blank?
        end

        def medium_counters(medium_ids)
          medium_types.each_with_object({}) do |mt, counters|
            return nil unless medium_ids

            counters[mt] = medium_ids[mt].try(:count).to_i
          end
        end

        def medium_types
          Medium::ALLOWED_TYPES.map(&:dasherize)
        end
      end
    end
  end
end
