# frozen_string_literal: true

require 'me_salva/event/user/cache'
require 'me_salva/event/user/permalink_data'

module MeSalva
  module Event
    module User
      class ConsumedModulesCache < ActiveModelSerializers::Model
        include ::MeSalva::Event::User::Cache
        include ::MeSalva::Event::User::PermalinkData
        attr_accessor :user_id, :permalink, :cache

        def initialize(attrs)
          super
          fetch
        end

        def update
          updated_data = cache_with_new_module
          write_modules_cache(updated_data)
          self.cache = updated_data.as_json
        end

        def build
          return if user_consumed_modules.blank?

          write_modules_cache(user_consumed_modules)
          self.cache = user_consumed_modules.as_json
        end

        def fetch
          self.cache = fetch_modules_cache
        end

        def flush
          flush_modules_cache
        end

        private

        def cache_with_new_module
          self.cache = [] if cache.nil?
          cache\
            .unshift(current_consumed_module_data.as_json)\
            .uniq { |e| [e['node'], e['node_module_id']] }
        end
      end
    end
  end
end
