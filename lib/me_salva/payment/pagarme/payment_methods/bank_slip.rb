# frozen_string_literal: true

module MeSalva
  module Payment
    module Pagarme
      module PaymentMethods
        module BankSlip
          def perform_bank_slip
            transaction = new_transaction(
              transaction_params.merge(bank_slip_params)
            )
            transaction.charge
          end

          private

          def new_customer_address
            Customer.new(order: @order).address
          end

          def bank_slip_params
            {
              payment_method: 'boleto',
              async: false
            }.merge(metadata)
          end
        end
      end
    end
  end
end
