# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreditCardsController, type: :controller do
  let(:valid_attributes) do
    { card_number: "4111111111111111", card_holder_name: "Andre Antunes Vieira",
      card_expiration_date: "0919", card_cvv: "080" }
  end
  let(:valid_stringify) { valid_attributes.stringify_keys }

  describe 'POST #create' do
    it_behaves_like 'a unauthorized create route for', %w[admin guest]

    context 'as user' do
      before do
        user_session
        card = double
        allow(PagarMe::Card).to receive(:new).with(valid_stringify)
                                             .and_return(card)
        allow(card).to receive(:create).and_return(card)
        allow(card).to receive(:id).and_return('card_cjuwydymb04mt9x6e5xr30pmk')
        allow(card).to receive(:valid).and_return(true)
      end
      let(:card_response) do
        MeSalva::Payment::Pagarme::Card.new.create(valid_stringify)
      end

      it 'returns card id' do
        post :create, params: valid_attributes

        assert_apiv2_response(:created, card_response, V2::CreditCardSerializer)
      end
    end
  end
end
