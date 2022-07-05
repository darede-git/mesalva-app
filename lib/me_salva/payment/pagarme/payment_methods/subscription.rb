# frozen_string_literal: true

module MeSalva
  module Payment
    module Pagarme
      module PaymentMethods
        module Subscription
          def perform_subscription
            subscription = PagarMe::Subscription.new(
              transaction_params.merge(subscription_params)
            )
            subscription.create
          end

          private

          def subscription_params
            { plan: pagarme_plan }.merge(authorization_method)
                                  .merge(metadata)
          end

          def authorization_method
            return card_token if @order.credit_card?

            { payment_method: 'boleto' }
          end

          def pagarme_plan
            PagarMe::Plan.find_by_id(@order.package.pagarme_plan_id)
          end
        end
      end
    end
  end
end
