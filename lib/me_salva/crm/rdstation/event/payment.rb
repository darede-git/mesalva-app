# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      module Event
        class Payment
          def initialize(**params)
            @order = params[:order]
          end

          def success
            return subscription_success_create if @order.subscription?

            package_success_create
          end

          def refused
            Client.new({ user: user,
                         event_name: 'pagamento-recusado',
                         payload: refused_attributes }).create
          end

          def bank_slip_generated
            Client.new({ user: user,
                         event_name: 'payment_wpp-boleto-gerado',
                         payload: bank_slip_attributes }).create
          end

          def bank_slip_expires_today
            Client.new({ user: user,
                         event_name: 'payment_wpp-boleto-vence-hoje',
                         payload: bank_slip_attributes }).create
          end

          def bank_slip_expired
            Client.new({ user: user,
                         event_name: 'payment_wpp-boleto-vencido',
                         payload: bank_slip_attributes }).create
          end

          def card_error
            Client.new({ user: user,
                         event_name: 'payment_wpp-cartao-erro',
                         payload: card_attributes }).create
          end

          private

          def subscription_success_create
            Client.new({ user: user,
                         event_name: 'assinatura-ativada',
                         payload: subscription_attributes }).create
          end

          def package_success_create
            Client.new({ user: user,
                         event_name: package_success_name,
                         payload: payment_attributes_success}).create
          end

          def package_success_name
            return 'pagamento-aprovado-pacote-boleto' if @order.bank_slip?

            'pagamento-aprovado-pacote-cartao'
          end

          def default_attributes
            {
              cf_checkout_celular: order_phone,
              cf_checkout_email: @order.email,
              cf_data_da_ordem: @order.created_at.to_s,
              cf_nome_do_produto: @order.package_name
            }
          end

          def payment_attributes
            default_attributes.merge(
              cf_valor_ultima_ordem: @order.price_paid.to_f.to_s
            )
          end

          def card_attributes
            default_attributes.merge(
              wpp_cartao_link: @order.package.slug
            )
          end

          def payment_attributes_success
            payment_attributes.merge(
              cf_package_sku: @order.package.sku
            )
          end

          def subscription_attributes
            payment_attributes.merge(
              cf_acesso_expira_em: expires_at,
              cf_subscription_id_pagarme: subscription_pagarme_id
            )
          end

          def bank_slip_attributes
            default_attributes.merge(
              cf_boleto_valor: @order.price_paid.to_f.to_s,
              cf_boleto_data_expiracao: (@order.created_at + 1.day).to_s,
              cf_boleto_codigo: barcode,
              cf_boleto_link: pdf
            )
          end

          def refused_attributes
            payment_attributes.merge(cf_checkout_error_code: error_code)
          end

          def error_code
            @order.payments.collect(&:error_code).join '-'
          end

          def pdf
            @order.payments.collect(&:pdf).join '-'
          end

          def barcode
            @order.payments.collect(&:barcode).join '-'
          end

          def expires_at
            (Time.now + 40.days).to_s
          end

          def subscription_pagarme_id
            @order.subscription&.pagarme_subscription&.pagarme_id
          end

          def order_phone
            "(#{@order.phone_area})#{@order.phone_number}"
          end

          def user
            @order.user
          end
        end
      end
    end
  end
end
