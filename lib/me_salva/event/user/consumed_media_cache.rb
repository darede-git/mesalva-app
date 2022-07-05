# frozen_string_literal: true

require 'me_salva/event/user/cache'
require 'me_salva/event/user/permalink_data'

module MeSalva
  module Event
    module User
      class ConsumedMediaCache < ActiveModelSerializers::Model
        include ::MeSalva::Event::User::Cache
        include ::MeSalva::Event::User::PermalinkData
        attr_accessor :user_id, :permalink, :cache

        def initialize(attrs)
          super
          fetch
        end

        def update
          add_medium_to_media_cache
          remove_media_cache_duplicates
          write_media_cache(cache)
          self.cache = cache.as_json
        end

        def build
          return if user_consumed_media.blank?

          write_media_cache(user_consumed_media)
          self.cache = user_consumed_media.as_json
        end

        def fetch
          self.cache = fetch_media_cache
        end

        def medium_ids(node_slug, node_module_id)
          return false if \
            cache[node_slug].nil? || cache[node_slug][node_module_id.to_s].nil?

          cache[node_slug][node_module_id.to_s]
        end

        def flush
          flush_media_cache
        end

        private

        def add_medium_to_media_cache
          build_media_cache_path_if_needed

          cache[current_education_segment.slug]\
            [current_node_module.id.to_s]\
            [current_medium_type] << current_medium.id
        end

        def remove_media_cache_duplicates
          cache[current_education_segment.slug]\
            [current_node_module.id.to_s]\
            [current_medium_type].uniq!
        end

        def build_media_cache_path_if_needed
          return build_base_cache_path if cache.nil?
          return build_education_segment_cache_path \
            if education_segment_cache_path.nil?
          return build_node_module_cache_path if node_module_cache_path.nil?
          return build_medium_type_cache_path if medium_type_cache_path.nil?
        end

        def build_medium_type_cache_path
          cache[current_education_segment.slug]\
            [current_node_module.id.to_s]\
            [current_medium_type] = []
        end

        def build_node_module_cache_path
          cache[current_education_segment.slug]\
            [current_node_module.id.to_s] = {
              current_medium_type => []
            }
        end

        def build_education_segment_cache_path
          cache[current_education_segment.slug] = {
            current_node_module.id.to_s => {
              current_medium_type => []
            }
          }
        end

        def build_base_cache_path
          self.cache = {
            current_education_segment.slug.to_s => {
              current_node_module.id.to_s => {
                current_medium_type => []
              }
            }
          }
        end

        def education_segment_cache_path
          cache[current_education_segment.slug]
        end

        def node_module_cache_path
          cache[current_education_segment.slug][current_node_module.id.to_s]
        end

        def medium_type_cache_path
          cache[current_education_segment.slug]\
            [current_node_module.id.to_s]\
            [current_medium_type]
        end
      end
    end
  end
end
