# frozen_string_literal: true

require ::File.expand_path('../boot', __FILE__)

require 'rails'
require 'active_record/railtie'
require 'action_mailer/railtie'

Bundler.require(*Rails.groups)

module BackendApi
  class Application < Rails::Application
    config.api_only = true
    config.debug_exception_response_format = :api
    config.i18n.default_locale = :'pt-BR'
    WillPaginate.per_page = ENV["PAGINATE_PER_PAGE"]

    config.eager_load_paths += %W[#{Rails.root}/lib]
    config.paths.add "app/serializers/concerns", eager_load: true

    config.generators do |g|
      g.assets = false
      g.helper = false
      g.template_engine = false
      g.orm = :active_record
      g.scaffold_controller :scaffold_controller
      g.test_framework :rspec, :routing_specs => false
    end

    config.middleware.delete Rack::Sendfile
    config.middleware.delete Rack::ETag
    config.middleware.delete ActionDispatch::Static
    config.middleware.delete ActionDispatch::Cookies
    config.middleware.delete ActionDispatch::Session::CookieStore
    config.middleware.delete ActionDispatch::Flash

    config.i18n.fallbacks = { 'pt-BR' => 'en' }
  end
end
