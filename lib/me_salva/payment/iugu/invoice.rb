# frozen_string_literal: true

require 'me_salva/payment/iugu/client'
require 'iugu'

module MeSalva
  module Payment
    module Iugu
      class Invoice
        include MeSalva::Payment::Iugu::Client

        def initialize
          set_api_key
        end

        def fetch(invoice_id)
          ::Iugu::Invoice.fetch(invoice_id)
        end

        def create(customer_id, due_date, items,
                   discount_cents, payable = 'all')
          ::Iugu::Invoice.create(customer_id: customer_id,
                                 due_date: due_date,
                                 items: items,
                                 discount_cents: discount_cents,
                                 payable_with: payable)
        end

        def search(customer_id)
          ::Iugu::Invoice.search(customer_id: customer_id).results
        end

        def find_invoice_id(hash)
          return hash['invoice_id'] if hash.key?('invoice_id')

          hash['recent_invoices'].empty? ? false : (hash['recent_invoices']).first['id']
        end

        def fetch_attributes(id)
          response = fetch(id)
          response.attributes
        end

        def refund(invoice_id)
          invoice = fetch(invoice_id)
          invoice.refund
        end
      end
    end
  end
end
