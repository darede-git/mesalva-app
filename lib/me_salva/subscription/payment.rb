# frozen_string_literal: true

module MeSalva
  module Subscription
    class Payment < RenewerBase
      def initialize(last_payment, transaction_class_name, **custom_attributes)
        @entity_to_renew = last_payment
        @new_entity_attributes = custom_attributes[:payment_attributes] || {}
        @transaction_attributes = custom_attributes[:transaction_attributes]
        @transaction_class_name = transaction_class_name
        @not_heritable_attributes = %w[order_id]
      end

      def renew
        super
        renew_transaction_and_create_relationship_with_payment
        @renewed_entity
      end

      private

      def renew_transaction_and_create_relationship_with_payment
        @renewed_entity.public_send(transaction_attribution_string,
                                    renewed_transaction)
      end

      def transaction_attribution_string
        "#{@transaction_class_name}="
      end

      def renewed_transaction
        MeSalva::Subscription::Transaction.new(
          transaction_to_renew, transaction_attributes:
                                        @transaction_attributes
        ).renew
      end

      def transaction_to_renew
        @entity_to_renew.public_send(@transaction_class_name)
      end
    end
  end
end
