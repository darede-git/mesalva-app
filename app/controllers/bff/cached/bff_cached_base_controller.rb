# frozen_string_literal: true

class Bff::Cached::BffCachedBaseController < ApplicationController
  def render_cached(fetcher, expires_in = default_cache_expires)
    begin
      if Rails.env.test? || ENV['BFF_CACHE_MINUTES'] == '0'
        return render_results(fetcher.call)
      end

      result = Rails.cache.fetch(default_cache_key, expires_in: expires_in) { fetcher.call }
      render_results(result)
    rescue StandardError => e
      puts e
      render_not_found
    end
  end

  def default_cache_expires
    return 10.minutes if ENV['BFF_CACHE_MINUTES'].nil?

    ENV['BFF_CACHE_MINUTES'].to_f.minutes
  end

  def default_cache_key
    base = "#{params[:controller]}/#{params[:action]}"
    key = Digest::MD5.hexdigest(params.to_json)
    "#{base}/#{params[:slug]}/#{key}"
  end

  private

  def no_cache
    Rails.env.test? || ENV['BFF_CACHE_MINUTES'] == '0'
  end
end
