# frozen_string_literal: true

class VoidCardWorker
  include Sidekiq::Worker

  def perform(order_payment_id)
    _payment = OrderPayment.find order_payment_id
    # TODO: Awaiting refund and avoid cards
  end
end
