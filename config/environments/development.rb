Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.default_url_options = { host: ENV['DEFAULT_URL'] }
  config.assets.compile = true
  config.debug_exception_response_format = :api

  if ENV['MEMCACHEDCLOUD_SERVERS']
    config.assets.cache_store = :dalli_store
    config.cache_store = :mem_cache_store,
      ENV["MEMCACHEDCLOUD_SERVERS"].split(','),
      { :username => ENV["MEMCACHEDCLOUD_USERNAME"],
        :password => ENV["MEMCACHEDCLOUD_PASSWORD"] }
  else
    config.cache_store = :mem_cache_store
    config.action_dispatch.rack_cache = {
      metastore:   'memcached://localhost:11211/meta',
      entitystore: 'memcached://localhost:11211/body'
    }
  end
  config.static_cache_control = "public, , max-age=2592000"
  config.generators do |g|
    g.factory_bot dir: 'spec/factories/'
  end
end
