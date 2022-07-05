# frozen_string_literal: true

class PersistCrmEventWorker
  include Sidekiq::Worker

  def perform(params)
    CrmEvent.create(params)
  end
end
