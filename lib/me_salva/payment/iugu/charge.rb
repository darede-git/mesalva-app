# frozen_string_literal: true

require 'me_salva/payment/iugu/client'
require 'iugu'

module MeSalva
  module Payment
    module Iugu
      class Charge
        include MeSalva::Payment::Iugu::Client

        def initialize
          set_api_key
        end

        def bank_slip(invoice_id, payer)
          ::Iugu::Charge.create(method: 'bank_slip',
                                invoice_id: invoice_id,
                                payer: payer)
        end

        def credit_card(items, user_payment_id, customer_id,
                        installments, discount_cents)
          ::Iugu::Charge.create(customer_id: customer_id,
                                customer_payment_method_id: user_payment_id,
                                items: items,
                                months: installments,
                                discount_cents: discount_cents)
        end
      end
    end
  end
end
