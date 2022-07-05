# frozen_string_literal: true

class PrepTestOverviewWorker
  include Sidekiq::Worker

  def perform(details)
    PrepTestOverview.create!(details)
  end
end
