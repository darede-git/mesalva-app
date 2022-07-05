# frozen_string_literal: true

module MeSalva
  module Subscription
    class Transaction < RenewerBase
      def initialize(last_transaction, **custom_attributes)
        @entity_to_renew = last_transaction
        @new_entity_attributes = custom_attributes[:transaction_attributes]
        @not_heritable_attributes = %w[transaction_id order_payment_id]
      end

      def renew
        super
        @renewed_entity
      end
    end
  end
end
