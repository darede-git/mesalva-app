require 'sidekiq'
require 'sidekiq/web'

Sidekiq.default_worker_options = { retry: ENV['WORKER_RETRY'].to_i }

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], size: ENV['REDIS_CONNECTIONS'].to_i }
  Rails.logger = Sidekiq::Logging.logger

  Rails.application.config.after_initialize do
    Rails.logger.info("DB Pool for Sidekiq Server before disconnect: #{ActiveRecord::Base.connection.pool.instance_variable_get('@size')}")
    ActiveRecord::Base.connection_pool.disconnect!

    ActiveSupport.on_load(:active_record) do
      config = Rails.application.config.database_configuration[Rails.env]
      config['reaping_frequency'] = ENV['DATABASE_REAP_FREQ'] || 10 # seconds
      config['pool'] = ENV['WORKER_DB_POOL'] || Sidekiq.options[:concurrency]
      ActiveRecord::Base.establish_connection(config)

      Rails.logger.info("DB Connection Pool size for Sidekiq Server is now: #{ActiveRecord::Base.connection.pool.instance_variable_get('@size')}")
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], size: 1 }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  user = ENV['SIDEKIQ_WEB_USER']
  password = ENV['SIDEKIQ_WEB_PASSWORD']
  [user, password]
end
