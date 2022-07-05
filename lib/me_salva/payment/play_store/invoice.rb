# frozen_string_literal: true

module MeSalva
  module Payment
    module PlayStore
      class Invoice
        attr_reader :order_id, :payment_state, :expiry_time_in_seconds,
                    :cancel_reason, :auto_renewing, :broker_data

        def initialize(order_data)
          @order_id = order_data['orderId']
          @payment_state = order_data['paymentState']
          @expiry_time_in_seconds = time_in_seconds(
            order_data['expiryTimeMillis']
          )
          @cancel_reason = order_data['cancelReason']
          @auto_renewing = order_data['autoRenewing']
          @broker_data = order_data
        end

        def paid_order?
          @payment_state.to_i == 1
        end

        def canceled_order?
          @cancel_reason.to_i == 1
        end

        def current_state
          return :canceled if canceled_order?

          return :paid if paid_order?

          :not_found
        end

        def current_order?(order)
          order.broker_invoice == @order_id
        end

        def incomplete_recurrency_process?(order)
          pending_payment? || recurrent_payment_pending?(order)
        end

        private

        def pending_payment?
          return false if @payment_state.nil?

          @payment_state.to_i.zero?
        end

        def recurrent_payment_pending?(order)
          current_order?(order) && will_be_renewed?
        end

        def will_be_renewed?
          @auto_renewing.to_s.underscore == 'true'
        end

        def time_in_seconds(time_in_millis)
          Time.at(time_in_millis.to_i / 1000)
        end
      end
    end
  end
end
