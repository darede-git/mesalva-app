# frozen_string_literal: true

require 'me_salva/payment/iugu/subscription'
require 'me_salva/payment/iugu/invoice'

module MeSalva
  module Signature
    class Order
      include UtmHelper
      include CrmEvents
      include RdStationHelper

      def initialize; end

      def renew(payment)
        payment.reload
        return create_next(payment) if expired?(payment)

        if subscription_suspended?
          payment.processed = true
          create_crm('account_renew_cancellation', payment.user, payment)
          send_rd_station_checkout_event(:expiration_event, payment.user, order.package)
        end
        payment.save!
      end

      def update(order)
        fetch_payment_status(order)
      end

      private

      def expired?(payment)
        @subscription = subscription_client.fetch(subs_broker_id(payment))
        return false if @subscription.nil?

        @invoice_id = invoice_client.find_invoice_id(@subscription.attributes)
        return false unless @invoice_id

        ::Order.find_by_broker_invoice(@invoice_id).nil?
      rescue Iugu::ObjectNotFound
        create_crm('account_renew_fail', order.user, order)
        send_rd_station_checkout_event(:expiration_event, order.user, order.package)
      end

      def subscription_suspended?
        @subscription&.attributes['suspended'] == true
      end

      def subs_broker_id(payment)
        payment.subscription_broker_id
      end

      def create_next(payment)
        order = ::Order.create(order_attributes(payment,
                                                @subscription,
                                                @invoice_id))
        create_crm('account_renew_success', order.user, order)
        payment.processed = true
        payment.save
      end

      def fetch_payment_status(order)
        order.reload
        return broker_invoice_nil(order) if order.broker_invoice.nil?

        invoice = invoice_client.fetch_attributes(order.broker_invoice)
        return false if invoice.nil?

        checkout_order(invoice, order)
        order.state_machine.transition_to(invoice['status'])
      rescue Iugu::ObjectNotFound
        nil
      end

      def broker_invoice_nil(order)
        order.state_machine.transition_to(:not_found)
        false
      end

      def checkout_order(invoice, order)
        if order_paid?(invoice)
          order.expires_at = expiration_date(order, invoice)
          order.save
          create_crm('checkout_success', order.user, order)
        end
        deactive_subscription(order) if subscription_expired?(order, invoice)
        return unless canceled_or_expired?(invoice)

        create_crm('checkout_fail', order.user, order) if order.credit_card?
        create_crm('boleto_expired', order.user, order) if order.bank_slip?
      end

      def subscription_expired?(order, invoice)
        order.subscription? && order_expired?(invoice)
      end

      def deactive_subscription(order)
        subscription = order.subscription
        subscription.active = false
        subscription.save
        send_rd_station_checkout_event(:expiration_event, order.user, order.package)
      end

      def expiration_date(order, invoice)
        return invoice['due_date'] unless order.subscription?

        subscription = subscription_client.fetch(order.subscription_broker_id)
        subscription.expires_at
      end

      def order_paid?(invoice)
        invoice['status'] == 'paid'
      end

      def order_expired?(invoice)
        invoice['status'] == 'expired'
      end

      def order_canceled?(invoice)
        invoice['status'] == 'canceled'
      end

      def canceled_or_expired?(invoice)
        order_expired?(invoice) || order_canceled?(invoice)
      end

      def status_code(key)
        ::Order.convert_status_key(key.to_sym)
      end

      def order_attributes(payment, subscription, invoice_id)
        { package_id: payment.package.id, user_id: payment.user_id,
          broker: 'iugu', price_paid: payment.price_paid,
          checkout_method: 'credit_card', currency: payment.currency,
          purchase_type: ::Order.convert_purchase_type_key(:renew),
          broker_data: subscription.attributes, processed: false,
          installments: 1, broker_invoice: invoice_id,
          email: payment.email, cpf: payment.cpf,
          nationality: payment.nationality,
          subscription_id: payment.subscription_id,
          address_attributes: address_attributes(payment.address) }
      end

      def address_attributes(address)
        { street: address.street, street_number: address.street_number,
          street_detail: address.street_detail,
          neighborhood: address.neighborhood,
          city: address.city, zip_code: address.zip_code,
          state: address.state, country: address.country,
          area_code: address.area_code, phone_number: address.phone_number }
      end

      def subscription_client
        @subscription_client ||= MeSalva::Payment::Iugu::Subscription.new
      end

      def invoice_client
        @invoice_client ||= MeSalva::Payment::Iugu::Invoice.new
      end
    end
  end
end
