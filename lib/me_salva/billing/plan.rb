# frozen_string_literal: true

module MeSalva
  module Billing
    class Plan
      def self.create(package)
        response = MeSalva::Payment::Pagarme::Plan.create(
          name: package.name,
          amount: DecimalAmount.new(package.gateway_plan_price).to_i
        )
        package.update!(pagarme_plan_id: response.id)
        response
      end

      def self.update(package)
        MeSalva::Payment::Pagarme::Plan.update(
          id: package.pagarme_plan_id,
          name: package.name
        )
      end
    end
  end
end
