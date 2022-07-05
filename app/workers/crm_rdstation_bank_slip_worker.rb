# frozen_string_literal: true

class CrmRdstationBankSlipWorker
  include Sidekiq::Worker
  include RdStationHelper

  def perform(order_id)
    order = ::Order.find(order_id)
    send_rd_station_payment_bankslip_event(:purchase_event, order)
  end
end
