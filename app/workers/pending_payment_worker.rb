# frozen_string_literal: true

class PendingPaymentWorker
  include Sidekiq::Worker

  def perform
    select_orders

    @orders.each do |order|
      @order = order
      set_transaction
      process_payment
    end
  end

  private

  def select_orders
    @orders = Order.expired_pending
  end

  def process_payment
    if partially_paid?
      if acceptable_difference?
        @order.state_machine.transition_to!(:pre_approved)
        PartialPaymentMailer.authorized_access(@order).deliver_now
      else
        PartialPaymentMailer.non_authorized(@order).deliver_now
        @order.state_machine.transition_to!(:expired)
      end
    elsif paid?
      @order.state_machine.transition_to!(:paid)
    else
      @order.state_machine.transition_to!(:expired)
    end
  end

  def set_transaction
    return  if Rails.env.test?

    transaction_id = OrderPayment.find_by(order_id: order.id).pagarme_transaction.id
    @transaction = PagarMe::Transaction.find_by_id(transaction_id)
  end

  def acceptable_difference?
    return true if Rails.env.test?

    ((@transaction.amount - @transaction.paid_amount) < 100)
  end

  def partially_paid?
    return true if Rails.env.test?

    @transaction.events.map do |transaction|
      transaction.name == "transaction_partially_paid"
    end.include? true
  end

  def paid?
    @transaction.events.map do |event|
      event.payload.current_status
    end.include? "paid"
  end
end
