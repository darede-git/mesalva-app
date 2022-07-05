# frozen_string_literal: true

module MeSalva
  module Payment
    module Pagarme
      class Plan
        class InvalidAmount < StandardError; end

        # `value` has to be float for the time being (legacy)
        def self.create(name:, amount:)
          raise InvalidAmount, "#{amount} é float" if amount.is_a?(Float)

          response = ::PagarMe::Plan.create(
            name: name,
            amount: amount,
            days: 30
          )

          Response.new(response)
        end

        def self.update(id:, name:)
          plan = ::PagarMe::Plan.find_by_id(id)
          plan.name = name
          Response.new(plan.save)
        end
      end
    end
  end
end
