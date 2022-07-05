# frozen_string_literal: true

class SimplybookSyncWorker
  include Sidekiq::Worker

  def perform(page = 1)
    MeSalva::Schedules::Bookings.new.sync_next_bookings(page)
  end
end
