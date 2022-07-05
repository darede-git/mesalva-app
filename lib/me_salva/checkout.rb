# frozen_string_literal: true

module MeSalva
  class Checkout
    def initialize(order:, user:, name:, email:, options: {})
      @order = order
      @user = user
      @name = name
      @email = email
      @options = options
    end

    def process
      return subscription_charge if @order.subscription?

      @order.payments.each do |payment|
        @charging = charge_payment(payment)
        save_payment_charge(payment)
      end
    end

    private

    def charge_payment(payment)
      MeSalva::Payment::Pagarme::Charge.new(payment, @name).perform(authorize?(payment))
    end

    def authorize?(payment)
      payment.card? && @order.multiple_payments?
    end

    def save_payment_charge(payment)
      payment.pdf = @charging.boleto_url
      payment.barcode = @charging.boleto_barcode || @charging.pix_qr_code
      payment.pagarme_transaction_attributes = { transaction_id: @charging.id,
                                                 order_payment: payment }
      payment.save
    end

    def subscription_charge
      return invalid_subscription if @order.payments.count > 1

      payment = @order.payments.first
      create_subscription
      @charging = charge_payment(payment) if @subscription.valid?
      update_entities(payment) if @charging
      update_bank_slip_url(payment) if payment.bank_slip?
      @order.save && @subscription.save
    end

    def update_bank_slip_url(payment)
      payment.update(pdf: @charging.current_transaction.boleto_url,
                     barcode: @charging.current_transaction.boleto_barcode)
    end

    def new_pagarme_subscription
      { pagarme_id: @charging.id, subscription: @subscription }
    end

    def create_subscription
      @subscription = ::Subscription.create(user: @user, orders: [@order])
      @order.update(subscription_id: @subscription.id)
    end

    def update_entities(payment)
      @subscription.pagarme_subscription_attributes = new_pagarme_subscription
      if subscription_paid?
        @subscription.update(active: true, status: 'paid')
        @order.update(expires_at: @charging.current_period_end)
        payment.reload.state_machine.transition_to!(:captured)
      end
      payment.pagarme_transaction_attributes = {
        transaction_id: @charging.current_transaction.id, order_payment: payment
      }
      payment.save && @subscription.save
    end

    def subscription_paid?
      @charging.status == 'paid'
    end

    def invalid_subscription
      raise MeSalva::Billing::Exceptions::InvalidSubscription
    end
  end
end
