# frozen_string_literal: true

class CrmRdstationPaymentRefusedWorker
  include Sidekiq::Worker
  include RdStationHelper

  def perform(order_id)
    order = ::Order.find(order_id)
    send_rd_station_event(event: :payment_refused, params: { order: order })
  end
end
