# frozen_string_literal: true

class CreditCardsController < ApplicationController
  before_action -> { authenticate(%w[user]) }

  def create
    render json: serialize(credit_card, serializer: 'CreditCard'), status: :created
  end

  private

  def credit_card
    MeSalva::Payment::Pagarme::Card.new.create(credit_card_params)
  end

  def credit_card_params
    params.permit(:card_number, :card_holder_name, :card_expiration_date,
                  :card_cvv).to_hash
  end
end
