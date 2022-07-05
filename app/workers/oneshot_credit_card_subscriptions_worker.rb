# frozen_string_literal: true

require 'me_salva/signature/order'

class OneshotCreditCardSubscriptionsWorker < BaseSignaturesWorker
  def perform
    Order.pending_order_one_shots_credit_card.by_iugu.each do |order|
      MeSalva::Signature::Order.new.update(order)
    end
  end
end
