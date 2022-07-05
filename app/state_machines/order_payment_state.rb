# frozen_string_literal: true

class OrderPaymentState
  include Statesman::Machine

  class InvalidState < StandardError; end

  state :pending, initial: true

  # credit cards
  state :authorizing
  state :authorized
  state :capturing
  state :captured
  state :voided

  state :canceled
  state :refunded
  state :paid
  state :failed

  transition from: :pending,     to: %i[authorizing paid failed captured]
  transition from: :authorizing, to: %i[authorized failed]
  transition from: :authorized,  to: %i[capturing voided]
  transition from: :capturing,   to: %i[captured failed]
  transition from: :captured,    to: %i[refunded failed]
  transition from: :paid,        to: %i[refunded]

  # rubocop:disable Style/SymbolProc
  guard_transition(to: :authorizing) do |payment|
    payment.card?
  end

  guard_transition(to: :paid) do |payment|
    payment.bank_slip? || payment.pix?
  end
  # rubocop:enable Style/SymbolProc

  guard_transition(to: :capturing) do |payment|
    payment.order.collectable? &&
      payment.order.all_bank_slips_paid?
  end

  after_transition(to: :authorized) do |payment|
    capture_all_cards(payment) if payment.state_machine.can_transition_to?(:capturing)
  end

  after_transition(to: :captured) do |payment|
    transit_order_to(payment.order, :paid) if payment.order.all_paid?
  end

  after_transition(to: :failed) do |payment|
    void_all_cards(payment)
    transit_order_to(payment.order, :canceled)
  end

  after_transition(to: :refunded) do |payment|
    void_all_cards(payment)
    transit_order_to(payment.order, :refunded)
  end

  after_transition(to: :paid) do |payment|
    transit_order_to(payment.order, :paid) if payment.order.all_paid?
    capture_all_cards(payment)
  end

  def self.transit_order_to(order, status)
    order.state_machine.transition_to(status)
  end

  def self.void_all_cards(payment)
    payment.order.payments.all.select(&:card?).each do |card|
      ::VoidCardWorker.perform_async(card.id)
    end
  end

  def self.capture_all_cards(payment)
    payment.order.payments.all.select(&:card?).each do |card|
      ::CaptureCardWorker.perform_async(card.id)
    end
  end

  private_class_method :capture_all_cards, :void_all_cards
end
