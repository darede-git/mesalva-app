# frozen_string_literal: true

require 'me_salva/signature/order'

class OneshotBankSlipSubscriptionsWorker < BaseSignaturesWorker
  def perform
    Order.pending_order_one_shots_bank_slip.by_iugu.each do |order|
      begin
        MeSalva::Signature::Order.new.update(order)
      rescue RestClient::BadGateway
        create_crm('checkout_error_validation', order.user, order)
      end
    end
  end
end
