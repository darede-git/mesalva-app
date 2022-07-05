# frozen_string_literal: true

module MeSalva
  module Event
    module User
      module Cache
        def fetch_modules_cache
          cache = redis.get(consumed_modules_key)
          return JSON.parse(cache) unless cache.nil?
        end

        def fetch_media_cache
          cache = redis.get(consumed_media_key)
          return JSON.parse(cache) unless cache.nil?
        end

        def write_modules_cache(data)
          redis.set(consumed_modules_key, data.to_json)
        end

        def write_media_cache(data)
          redis.set(consumed_media_key, data.to_json)
        end

        def flush_media_cache
          redis.del(consumed_media_key)
        end

        def flush_modules_cache
          redis.del(consumed_modules_key)
        end

        private

        def consumed_media_key
          "consumed_media.#{user_id}"
        end

        def consumed_modules_key
          "consumed_modules.#{user_id}"
        end

        def redis
          ::Redis.current
        end
      end
    end
  end
end
