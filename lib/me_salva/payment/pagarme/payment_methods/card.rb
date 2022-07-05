# frozen_string_literal: true

module MeSalva
  module Payment
    module Pagarme
      module PaymentMethods
        module Card
          def perform_capture
            transaction = ::PagarMe::Transaction.new(
              transaction_params.merge(credit_card_params)
            )
            transaction.charge
          end

          def perform_authorize
            @payment.state_machine.transition_to!(:authorizing)
            transaction = new_transaction(
              transaction_params.merge(credit_card_params)
                                             .merge(capture: false)
            )
            transaction.charge
          end

          private

          def credit_card_params
            {
              payment_method: 'credit_card',
              installments: @payment.installments,
              async: true
            }.merge(card_token).merge(metadata)
          end

          def card_token
            { card_id: @payment.card_token }
          end
        end
      end
    end
  end
end
