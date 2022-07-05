# frozen_string_literal: true

class PrepTestDetailWorker
  include Sidekiq::Worker

  def perform(details)
    PrepTestDetail.create!(details)
  end
end
