# frozen_string_literal: true

require 'me_salva/signature/order'

class PendingSubscriptionsWorker < BaseSignaturesWorker
  def perform
    Order.pending_order_subscriptions.by_iugu.each do |order|
      MeSalva::Signature::Order.new.update(order)
    end
  end
end
