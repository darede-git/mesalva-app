# frozen_string_literal: true

require 'me_salva/event/user/last_modules_cache'

class UpdateUserLastModulesCacheWorker
  include Sidekiq::Worker

  def perform(user_id, permalink_id)
    cache = MeSalva::Event::User::LastModulesCache.new(
      user_id: user_id, permalink_id: permalink_id
    )
    cache.update
  end
end
