# frozen_string_literal: true

require 'me_salva/payment/iugu/client'
require 'iugu'

module MeSalva
  module Payment
    module Iugu
      class Subscription
        include MeSalva::Payment::Iugu::Client

        def initialize
          set_api_key
        end

        def fetch(subscription_id)
          ::Iugu::Subscription.fetch(subscription_id)
        end

        def create(plan_identifier, customer_id)
          ::Iugu::Subscription.create(plan_identifier: plan_identifier,
                                      customer_id: customer_id,
                                      only_on_charge_success: true)
        end

        def suspend(subscription_id)
          subscription = fetch(subscription_id)
          subscription.suspend
        end
      end
    end
  end
end
