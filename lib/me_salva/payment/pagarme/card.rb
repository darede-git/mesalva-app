# frozen_string_literal: true

require 'pagarme'

module MeSalva
  module Payment
    module Pagarme
      class Card
        attr_reader :id, :valid

        def create(card_params)
          return nil unless card_params.present?

          card = ::PagarMe::Card.new(card_params).create
          @id = card.id
          @valid = card.valid
          self
        end

        def index(customer_id)
          return [] unless customer_id.present?

          ::PagarMe::Card.where(customer_id: customer_id.to_s)
        end

        def show(card_id)
          return nil unless card_id.present?

          ::PagarMe::Card.find(card_id.to_s)
        end
      end
    end
  end
end
