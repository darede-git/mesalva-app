# frozen_string_literal: true

module MeSalva
  module Payment
    module PlayStore
      class Subscription
        def initialize
          @client = Client.new
        end

        def process(last_order)
          invoice = @client.subscription_last_invoice_from(last_order)
          return if invoice.incomplete_recurrency_process?(last_order)

          renew(last_order, invoice) unless invoice.current_order?(last_order)
          last_order.update!(processed: true)
        end

        private

        def renew(last_order, new_invoice)
          new_order = MeSalva::Subscription::Order.new(
            last_order,
            transaction_attributes: new_transaction_attributes(last_order,
                                                               new_invoice),
            order_attributes: new_order_attributes(last_order, new_invoice)
          ).renew
          transit_order_state(new_order, new_invoice)
          new_order.update!(processed: true) if new_invoice.canceled_order?
        end

        def new_order_attributes(last_order, new_invoice)
          { broker_invoice: new_invoice.order_id,
            expires_at: new_invoice.expiry_time_in_seconds,
            broker_data: last_order.broker_data.merge(new_invoice.broker_data) }
        end

        def new_transaction_attributes(last_order, new_invoice)
          { metadata: merged_metadata(last_order, new_invoice),
            transaction_id: new_invoice.order_id }
        end

        def merged_metadata(order, invoice)
          order.play_store_transaction.metadata.merge(invoice.broker_data)
        end

        def transit_order_state(order, invoice)
          order.state_machine.transition_to!(invoice.current_state)
        end
      end
    end
  end
end
