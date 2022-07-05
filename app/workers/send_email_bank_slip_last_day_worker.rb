# frozen_string_literal: true

class SendEmailBankSlipLastDayWorker
  include Sidekiq::Worker
  include SendEmailBankSlipHelper
  include RdStationHelper
  include CrmEvents

  def perform(order_id)
    order = Order.find(order_id)
    return if order_paid?(order)

    CheckoutMailer.with(order: order,
                        email_type: 'bank_slip_last_day')
                  .bank_slip_email
                  .deliver_now
    send_rd_station_event({ event: 'payment_bank_slip_expires_today', params: { user: order.user,
                                                                                package: order.package } })
    create_crm('wpp_boleto_vence_hoje', order.user, order)
  end
end
