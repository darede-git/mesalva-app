# frozen_string_literal: true

require 'me_salva/payment/iugu/invoice'
require 'iugu'

module MeSalva
  module Payment
    module Iugu
      class Order
        def self.reprocess
          find_not_found_orders.each do |order|
            broker = ::Iugu::Invoice.fetch(order.broker_invoice)
            fix_order_status(order) if broker_status_paid?(broker)
          end
        end

        def self.broker_status_paid?(broker)
          broker.status == 'paid'
        end

        def self.fix_order_status(order)
          order.destroy_not_found_transitions
          order.transition_to_paid
        end

        def self.find_not_found_orders
          ::Order.where("status = 7 AND
                         broker_invoice IS NOT NULL AND
                         broker = 'iugu'")
        end

        private_class_method :broker_status_paid?,
                             :fix_order_status,
                             :find_not_found_orders
      end
    end
  end
end
