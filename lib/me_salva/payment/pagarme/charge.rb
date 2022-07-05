# frozen_string_literal: true

require 'pagarme'

module MeSalva
  module Payment
    module Pagarme
      class Charge
        include Client
        include PaymentMethods::BankSlip
        include PaymentMethods::Pix
        include PaymentMethods::Card
        include PaymentMethods::Subscription

        def initialize(payment, billing_name)
          set_api_key
          @order = payment.order
          @payment = payment
          @user = @order.user
          @address = @order.address
          @billing_name = billing_name || @user.name
          @customer = customer
          @main_package = main_package
          @complementary_packages = complementary_packages
        end

        def perform(authorize = nil)
          return perform_subscription if @payment.order.subscription?

          return perform_authorize if authorize

          return perform_capture if @payment.card?
          return perform_pix if @payment.pix?

          perform_bank_slip
        end

        private

        def transaction_params
          { amount: @payment.amount_in_cents,
            postback_url: ENV['POSTBACK_URL'],
            customer: @customer.personal_data }.merge(metadata)
        end

        def customer
          Customer.new(order: @order, billing_name: @billing_name)
        end

        def new_transaction(attributes)
          ::PagarMe::Transaction.new(attributes)
        end

        def billing
          { name: "default",
            address: { neighborhood: @address.try(:neighborhood),
                       zipcode: address_zip_code,
                       city: @address.try(:city),
                       state: @address.try(:state),
                       complementary: @address.try(:street_detail) || 'não informado',
                       country: "br",
                       street: @address.try(:street),
                       street_number: @address.try(:street_number).to_s } }
        end

        def address_zip_code
          @address.try(:zip_code).gsub(/-/, '') if @address.try(:zip_code)
        end

        def items
          return items_with_books_metadata if @main_package.options['books']

          all_items_metadata = []
          all_items_metadata << items_metadata(@main_package)
          all_items_metadata.concat(@complementary_packages.map { |cp| items_metadata(cp) })
        end

        def items_metadata(package)
          { id: package.id.to_s,
            title: package.name,
            unit_price: payment_proportional_value(package).round,
            quantity: 1,
            tangible: false,
            category: package.sku || 'empty' }
        end

        def items_with_books_metadata
          [{ id: "#{@main_package.id}-service",
             title: "#{@main_package.name} (Serviço)",
             unit_price: ((1 - products_percentage / 100) * @payment.amount_in_cents).round,
             quantity: 1,
             tangible: false,
             category: @main_package.sku || 'empty' },
           { id: "#{@main_package.id}-products",
             title: "#{@main_package.name} (Produtos)",
             unit_price: (products_percentage * @payment.amount_in_cents / 100).round,
             quantity: 1,
             tangible: true,
             category: 'products' }]
        end

        def metadata
          { billing: billing,
            items: items,
            metadata: { user_id: @user.id,
                        nome: @billing_name,
                        logradouro: @address.try(:street),
                        numero: @address.try(:street_number),
                        complemento: @address.try(:street_detail),
                        bairro: @address.try(:neighborhood),
                        cidade: @address.try(:city),
                        estado: @address.try(:state),
                        cep: @address.try(:zip_code),
                        'produto-comprado': @order.package.name,
                        'tempo-de-duração-do-produto': @order.package.duration,
                        'order-id': @order.id,
                        'order-token': @order.token,
                        'data-da-compra': Time.now.to_s,
                        'admin-order': "#{ENV['DEFAULT_ADMIN_URL']}/ordens/#{@order.token}",
                        'admin-user': "#{ENV['DEFAULT_ADMIN_URL']}/estudantes/#{@user.uid}"} }
        end

        def products_percentage
          pack.options['books'][@payment.payment_method]
        end

        def main_package
          @order.package
        end

        def complementary_packages
          cp = []
          @order.complementary_package_ids.each do |cp_id|
            cp << Package.find(cp_id)
          end
          cp
        end

        def payment_proportional_value(package)
          total_value = @order.price_paid.to_f * 100
          payment_value = @payment.amount_in_cents
          package_value = package.prices.find_by_price_type(payment_method).value.to_f * 100
          payment_proportion = (package_value * 100) / total_value / 100
          payment_value * payment_proportion
        end

        def payment_method
          return 'credit_card' if @payment.payment_method == 'card'

          @payment.payment_method
        end

        def card_token
          { card_id: @payment.card_token }
        end
      end
    end
  end
end
