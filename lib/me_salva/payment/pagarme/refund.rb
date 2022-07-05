# frozen_string_literal: true

require 'pagarme'

module MeSalva
  module Payment
    module Pagarme
      class Refund < ActiveModelSerializers::Model
        include Client

        attr_accessor :order

        def perform
          order.payments.each { |payment| refund_payment(payment) }
        end

        private

        def refund_payment(payment)
          transaction = ::PagarMe::Transaction.find_by_id(
            payment.pagarme_transaction.transaction_id
          )
          transaction.refund
        end
      end
    end
  end
end
