# frozen_string_literal: true

class CrmRdstationUnsubscriberEventWorker
  include Sidekiq::Worker
  include RdStationHelper

  def perform(subscription_id)
    subscription = ::Subscription.find(subscription_id)
    send_rd_station_event(event: :subscription_unsubscribe, params: { subscription: subscription })
  end
end
