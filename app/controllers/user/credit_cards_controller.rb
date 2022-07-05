# frozen_string_literal: true

class User::CreditCardsController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :set_user_credit_card, only: %i[show]

  def index
    user_credit_cards = MeSalva::Payment::Pagarme::Card.new.index(customer_id)
    render json: serialize(user_credit_cards, serializer: 'UserCreditCard'), status: :ok
  end

  def show
    return render_bad_request if empty_card_id?

    if @user_credit_card
      render json: serialize(@user_credit_card, serializer: 'UserCreditCard'), status: :ok
    else
      render_not_found
    end
  end

  def create
    return render_bad_request if empty_card?

    @user_credit_card = MeSalva::Payment::Pagarme::Card.new.create(user_credit_card_params \
      .merge("customer_id" => customer_id))
    if valid_card_created?
      render json: serialize(@user_credit_card, serializer: 'UserCreditCardCreate'), status: :created
    else
      render_unprocessable_entity
    end
  end

  private

  def customer_id
    current_user.pagarme_customer_id
  end

  def empty_card?
    !user_credit_card_params['card_number'].present? ||
      !user_credit_card_params['card_holder_name'].present? ||
      !user_credit_card_params['card_expiration_date'].present? ||
      !user_credit_card_params['card_cvv'].present?
  end

  def valid_card_created?
    @user_credit_card.present? && @user_credit_card.valid
  end

  def empty_card_id?
    !params['id'].present?
  end

  def set_user_credit_card
    @user_credit_card = MeSalva::Payment::Pagarme::Card.new.show(params['id'])
  end

  def user_credit_card_params
    params.permit(:card_number, :card_holder_name, :card_expiration_date, :card_cvv).to_hash
  end
end
