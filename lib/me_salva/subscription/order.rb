# frozen_string_literal: true

module MeSalva
  module Subscription
    class Order < RenewerBase
      def initialize(last_order, **custom_attributes)
        @entity_to_renew = last_order
        @new_entity_attributes = custom_attributes[:order_attributes]
        @payment_attributes = custom_attributes[:payment_attributes]
        @transaction_attributes = custom_attributes[:transaction_attributes]
        @not_heritable_attributes = %w[token status expires_at purchase_type
                                       processed broker_invoice discount_id]
      end

      def renew
        super
        renew_payment_and_create_relationship_with_order
        duplicate_address
        @renewed_entity if @renewed_entity.save!
      end

      private

      def renew_payment_and_create_relationship_with_order
        @renewed_entity.payments = [new_payment]
      end

      def new_payment
        MeSalva::Subscription::Payment.new(
          payment_to_renew, transaction_class_name,
          payment_attributes: @payment_attributes,
          transaction_attributes: @transaction_attributes
        ).renew
      end

      def transaction_class_name
        "#{@entity_to_renew.broker}_transaction"
      end

      def payment_to_renew
        @entity_to_renew.payments.take
      end

      def duplicate_address
        return if @entity_to_renew.address.nil?

        @renewed_entity.address = @entity_to_renew.address.dup
      end
    end
  end
end
