# frozen_string_literal: true

module Cache
  extend ActiveSupport::Concern

  included do
    skip_before_action :expires_now, only: :index
    before_action :cache_expiration_time, only: :index
    before_action :flush_cache, only: :update
  end

  def last_update_for(entities)
    entities.maximum(:updated_at)
  end

  def cache_expiration_time
    expires_in(Integer(ENV['CACHE_EXPIRATION_HOURS'] || 6)
      .hours, skip_digest: true)
  end

  def flush_cache
    Rails.cache.clear
  end
end
