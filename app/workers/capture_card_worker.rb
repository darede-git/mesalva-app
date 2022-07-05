# frozen_string_literal: true

class CaptureCardWorker
  include Sidekiq::Worker

  def perform(order_payment_id)
    payment = OrderPayment.find order_payment_id
    transaction = PagarMe::Transaction.find_by_id(payment.transaction_id)
    transaction&.capture(amount: payment.amount_in_cents)
    payment.state_machine.transition_to!(:capturing)
  end
end
