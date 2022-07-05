# frozen_string_literal: true

require 'pagarme'
module MeSalva
  module Payment
    module Pagarme
      class Postback < ActiveModelSerializers::Model
        include IntercomHelper
        attr_accessor :entity, :status, :current_transaction_id,
                      :next_recurrence_date, :amount_paid, :payment_method,
                      :bank_slip_url, :pix_qr_code, :error_code

        def process
          return payment_transition if entity.is_a? OrderPayment

          subscription_renew if current_transaction_id && next_recurrence_date
        end

        def self.valid_signature?(request)
          ::PagarMe::Postback.valid_request_signature?(
            request.body.string, request.headers['X-Hub-Signature']
          )
        end

        private

        def payment_transition
          save_error_code if refused? && error_code
          bank_slip_intercom_event if bank_slip_paid_postback?
          pix_intercom_event if pix_paid_postback?
          return true if pending_refund?

          entity.state_machine.transition_to(original_status)
        end

        def bank_slip_paid_postback?
          entity.bank_slip? && paid?
        end

        def pix_paid_postback?
          entity.pix? && paid?
        end

        def bank_slip_intercom_event
          create_intercom_event('bank_slip_paid', entity.order.user)
        end

        def pix_intercom_event
          create_intercom_event('pix_paid', entity.order.user)
        end

        def save_error_code
          entity.update(error_code: error_code)
          error_message = MeSalva::Payment::Pagarme::ErrorCodeModule
                          .error_message(error_code)
          entity.update(error_message: error_message)
        end

        def subscription_renew
          create_recurrence unless transaction_exists?
          return true if subscription_by_bank_slip?

          entity.renew(@payment, status, next_recurrence_date)
        end

        def transaction_exists?
          @payment = PagarmeTransaction.find_by_transaction_id(
            current_transaction_id
          ).try(:order_payment)
        end

        def transit_last_transaction
          entity.last_order.update(expires_at: next_recurrence_date)
          entity.last_order.state_machine.transition_to!(:paid)
          entity.update(status: 'paid', active: true)
        end

        def create_recurrence
          transit_last_transaction if subscription_by_bank_slip_paid?
          last_order = entity.last_order
          new_order = MeSalva::Subscription::Order.new(
            last_order,
            order_attributes: new_order_attributes,
            payment_attributes: new_payment_attributes,
            transaction_attributes: new_transaction_attributes
          ).renew
          @payment = new_order.payments.take
        end

        def subscription_by_bank_slip_paid?
          paid? && subscription_by_bank_slip?
        end

        def subscription_by_bank_slip?
          payment_method == 'bank_slip'
        end

        def original_status
          return 'captured' if paid? && card?
          return 'failed' if refused?

          status
        end

        def card?
          @payment.try(:card?) || entity.card?
        end

        def paid?
          status == 'paid'
        end

        def pending_refund?
          status == 'pending_refund'
        end

        def refused?
          %w[refused canceled].include? status
        end

        def new_payment_attributes
          { payment_method: payment_method, pdf: bank_slip_url, installments: 1,
            amount_in_cents: DecimalAmount.new(amount_paid).to_i }
        end

        def new_order_attributes
          { expires_at: next_recurrence_date }
        end

        def new_transaction_attributes
          { transaction_id: current_transaction_id }
        end
      end
    end
  end
end
