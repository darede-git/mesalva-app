# frozen_string_literal: true

module MeSalva
  module Payment
    module PlayStore
      class Refund
        def initialize(order)
          @order = order
          @client = MeSalva::Payment::PlayStore::Client.new
        end

        def perform
          return false unless @order.refundable?

          @client.refund(@order)
        end
      end
    end
  end
end
