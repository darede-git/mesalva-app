# frozen_string_literal: true

class SendEmailBankSlipOverduedWorker
  include Sidekiq::Worker
  include SendEmailBankSlipHelper
  include RdStationHelper
  include CrmEvents

  def perform(order_id)
    order = Order.find(order_id)
    return if order_paid?(order)

    CheckoutMailer.with(order: order,
                        email_type: 'bank_slip_overdue')
                  .bank_slip_overdued_email
                  .deliver_now
    send_rd_station_event({ event: 'payment_bank_slip_expired', params: { user: order.user,
                                                                          package: order.package } })
    create_crm('wpp_boleto_vencido', order.user, order)
  end
end
