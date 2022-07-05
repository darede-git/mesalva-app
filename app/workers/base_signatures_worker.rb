# frozen_string_literal: true

class BaseSignaturesWorker
  include Sidekiq::Worker
  include CrmEvents
end
