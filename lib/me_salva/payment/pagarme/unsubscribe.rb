# frozen_string_literal: true

require 'pagarme'

module MeSalva
  module Payment
    module Pagarme
      class Unsubscribe < ActiveModelSerializers::Model
        include Client

        attr_accessor :subscription

        def perform
          unsubscribe(subscription.pagarme_subscription.pagarme_id)
        end

        private

        def unsubscribe(pagarme_id)
          pagarme_subscription = ::PagarMe::Subscription.find_by_id(pagarme_id)
          pagarme_subscription.cancel
        end
      end
    end
  end
end
