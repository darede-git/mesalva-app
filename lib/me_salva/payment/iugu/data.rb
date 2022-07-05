# frozen_string_literal: true

require 'me_salva/payment/iugu/customer'
require 'me_salva/payment/iugu/payment_method'
require 'me_salva/payment/iugu/subscription'
require 'me_salva/payment/iugu/charge'
require 'me_salva/payment/iugu/invoice'

module MeSalva
  module Payment
    module Iugu
      class Data
        def initialize(order, user, token, name, email)
          @order = order
          @user = user
          @token = token.delete('_') if token
          @name = name
          @email = email
        end

        def persist
          broker_user
          return process_error(@errors) if @errors

          save_broker_customer_id
          if @order.credit_card?
            payment_with_credit_card
          else
            payment_with_bank_slip
          end
        end

        private

        def payment_with_credit_card
          persist_payment_method
          return process_error(@payment_method.errors) if @payment_method.errors.present?
          return create_subscription if @order.subscription?

          create_charge_credit_card
        end

        def persist_payment_method
          @payment_method = payment_method_client.create(
            @broker_user,
            @token
          )
        end

        def create_subscription
          subscription = subscription_client.create(
            @order.package.iugu_plan_identifier,
            @broker_user.id
          )
          return process_error(subscription.errors) if subscription.errors

          persist_subscription_id(subscription)
          persist_broker_data(subscription)
        end

        def persist_subscription_id(broker_subscription)
          subscription = ::Subscription
                         .create(user: @user,
                                 active: true,
                                 broker_id: broker_subscription.id)
          @order.subscription_id = subscription.id
        end

        def create_charge_credit_card
          charge = charge_client.credit_card(items,
                                             @payment_method.id,
                                             @broker_user.id,
                                             @order.installments,
                                             convert_to_cents(discount))
          persist_broker_data(charge)
        end

        def persist_broker_data(broker_response)
          return process_error(broker_response.errors) if broker_response.errors.present?

          save_order_broker_data(broker_response)
        end

        def save_order_broker_data(broker_response)
          attributes = broker_response.attributes
          @order.broker_data = attributes
          @order.broker_invoice = invoice_client.find_invoice_id(attributes)
          @order.price_paid = price.value
          @order.discount_in_cents = convert_to_cents(discount)
          @order.save
          attributes
        end

        def process_error(error)
          save_state_machine_to_invalid
          @order.broker_data = error
          @order.save
          { errors: error }
        end

        def save_state_machine_to_invalid
          @order.state_machine.transition_to(:invalid)
        end

        def items
          [{
            description: @order.package.name,
            quantity: '1',
            price_cents: price_cents
          }]
        end

        def price_cents
          return if price.nil?

          convert_to_cents(price.value)
        end

        def price
          @price ||= Price.by_package_and_price_type(@order.package.id,
                                                     @order.checkout_method)
        end

        def convert_to_cents(value)
          return if value.nil?

          (value.to_f * 100).to_i
        end

        def discount
          return if price.nil?

          @discount ||= (price.value.to_f * percentage)
        end

        def percentage
          return 0 unless @order.discount.present?

          (@order.discount.percentual.to_f / 100)
        end

        def payment_with_bank_slip
          invoice = create_invoice
          return process_error(invoice.errors) if invoice.errors.present?

          charge = charge_client.bank_slip(invoice.id, payer)
          persist_broker_data(charge)
        end

        def create_invoice
          invoice_client.create(@broker_user.id, due_date, items,
                                convert_to_cents(discount), 'bank_slip')
        end

        def due_date
          Time.now + 3.days
        end

        def payer
          { name: @name,
            email: @email }
        end

        def broker_user
          broker_user_by_customer_id if @user.iugu_customer_id?
          @broker_user ||= create_broker_user
          change_customer_info
          broker_user_errors
        rescue MeSalva::Payment::Iugu::Customer::Iugu::ObjectNotFound
          @errors = 'Inexistent broker customer id'
        end

        def broker_user_inconsistency
          @broker_user.nil? && @user.iugu_customer_id.present?
        end

        def broker_user_by_customer_id
          @broker_user = customer_client.fetch(@user.iugu_customer_id)
        end

        def create_broker_user
          customer_client.create(broker_user_params)
        end

        def broker_user_params
          { email: @email, name: @name, cpf_cnpj: @order.cpf,
            zip_code: @order.address.zip_code, street: @order.address.street,
            number: @order.address.street_number,
            district: @order.address.neighborhood, state: @order.address.state,
            city: @order.address.city }
        end

        def broker_user_errors
          @errors = @broker_user.errors if @broker_user.errors.present?
        end

        def change_customer_info
          broker_user_params.each do |key, value|
            next if value.nil?

            @broker_user.public_send("#{key}=", value)
          end
          @broker_user.save
        end

        def save_broker_customer_id
          @user.iugu_customer_id ||= @broker_user.id
          @user.save!
        end

        def customer_client
          @customer_client ||= MeSalva::Payment::Iugu::Customer.new
        end

        def payment_method_client
          @payment_method_client ||= MeSalva::Payment::Iugu::PaymentMethod.new
        end

        def subscription_client
          @subscription_client ||= MeSalva::Payment::Iugu::Subscription.new
        end

        def charge_client
          @charge_client ||= MeSalva::Payment::Iugu::Charge.new
        end

        def invoice_client
          @invoice_client ||= MeSalva::Payment::Iugu::Invoice.new
        end
      end
    end
  end
end
