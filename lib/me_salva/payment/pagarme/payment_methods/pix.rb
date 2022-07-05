# frozen_string_literal: true

module MeSalva
  module Payment
    module Pagarme
      module PaymentMethods
        module Pix
          def perform_pix
            transaction = new_transaction(
              transaction_params.merge(pix_params)
            )
            transaction.charge
          end

          private

          def new_customer_address
            Customer.new(order: @order).address
          end

          def pix_params
            {
              payment_method: 'pix',
              pix_expiration_date: Time.now + 5.minutes,
              async: false
            }.merge(metadata)
          end
        end
      end
    end
  end
end
