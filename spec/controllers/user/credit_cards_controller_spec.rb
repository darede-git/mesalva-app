# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::CreditCardsController, type: :controller do
  include PermissionHelper
  let(:default_serializer) { V2::UserCreditCardSerializer }

  context '#index' do
    context 'as user' do
      before { user_session }
      context 'with a valid pagarme customer id' do
        before { user.update(pagarme_customer_id: 1_234_567) }
        let(:customer_id) { user.pagarme_customer_id }
        context 'and valid credit cards for this user' do
          let(:credit_card_example1) do
            ::PagarMe::Card.new({ "card_number" => "4111111111111111",
                                  "card_holder_name" => "Customer Name Example",
                                  "card_expiration_date" => "0919",
                                  "card_cvv" => "080",
                                  "customer_id" => user.pagarme_customer_id })
          end
          let(:credit_card_example2) do
            ::PagarMe::Card.new({ "card_number" => "4111111111111112",
                                  "card_holder_name" => "Customer Name Example 2",
                                  "card_expiration_date" => "0920",
                                  "card_cvv" => "081",
                                  "customer_id" => user.pagarme_customer_id })
          end
          context 'and another user' do
            let(:another_customer) do
              create(:user, pagarme_customer_id: 2_345_678)
            end
            context 'with a valid credit card for this other user' do
              let(:credit_card_example3) do
                ::PagarMe::Card.new({ "card_number" => "4111111111111113",
                                      "card_holder_name" => "Customer Name Example 3",
                                      "card_expiration_date" => "0921",
                                      "card_cvv" => "082",
                                      "customer_id" => another_customer.pagarme_customer_id })
              end
              before do
                card = [credit_card_example1, credit_card_example2]
                allow(PagarMe::Card).to receive(:where).with({ customer_id: customer_id })
                                                       .and_return(card)
              end
              let(:card_response) do
                MeSalva::Payment::Pagarme::Card.new.index(customer_id)
              end
              it 'returns all and only current user credit cards' do
                get :index

                assert_apiv2_response(:ok,
                                      [credit_card_example1, credit_card_example2],
                                      default_serializer)
              end
            end
          end
        end
      end
      context 'for a user with a null pagarme customer id' do
        let(:user_with_invalid_customer_id) { create(:user, pagarme_customer_id: nil) }
        let(:customer_id) { user_with_invalid_customer_id.pagarme_customer_id }
        context 'and valid credit cards for another user' do
          let(:credit_card_example1) do
            { "card_number" => "4111111111111111",
              "card_holder_name" => "Customer Name Example",
              "card_expiration_date" => "0919",
              "card_cvv" => "080",
              "customer_id" => user.pagarme_customer_id }
          end
          let(:credit_card_example2) do
            { "card_number" => "4111111111111112",
              "card_holder_name" => "Customer Name Example 2",
              "card_expiration_date" => "0920",
              "card_cvv" => "081",
              "customer_id" => user.pagarme_customer_id }
          end
          before do
            card = []
            allow(PagarMe::Card).to receive(:where).with({ customer_id: customer_id })
                                                   .and_return(card)
          end
          let(:card_response) do
            MeSalva::Payment::Pagarme::Card.new.index(customer_id)
          end
          it 'returns an empty user credit cards list' do
            get :index

            expect(response).to have_http_status(:ok)
            expect(parsed_response['data'].count).to eq(0)
          end
        end
      end
      context 'for a user with an empty pagarme customer id' do
        let(:user_with_invalid_customer_id) { create(:user, pagarme_customer_id: '') }
        let(:customer_id) { user_with_invalid_customer_id.pagarme_customer_id }
        context 'and valid credit cards for another user' do
          let(:credit_card_example1) do
            { "card_number" => "4111111111111111",
              "card_holder_name" => "Customer Name Example",
              "card_expiration_date" => "0919",
              "card_cvv" => "080",
              "customer_id" => user.pagarme_customer_id }
          end
          let(:credit_card_example2) do
            { "card_number" => "4111111111111112",
              "card_holder_name" => "Customer Name Example 2",
              "card_expiration_date" => "0920",
              "card_cvv" => "081",
              "customer_id" => user.pagarme_customer_id }
          end
          before do
            card = []
            allow(PagarMe::Card).to receive(:where).with({ customer_id: customer_id })
                                                   .and_return(card)
          end
          let(:card_response) do
            MeSalva::Payment::Pagarme::Card.new.index(customer_id)
          end
          it 'returns an empty user credit cards list' do
            get :index

            expect(response).to have_http_status(:ok)
            expect(parsed_response['data'].count).to eq(0)
          end
        end
      end
    end
  end

  context '#show' do
    context 'as user' do
      before { user_session }
      context 'for a valid credit card' do
        let(:card_id) { 'card_1' }
        let(:credit_card_example) do
          ::PagarMe::Card.new({ "card_number" => "4111111111111111",
                                "card_holder_name" => "Customer Name Example",
                                "card_expiration_date" => "0919",
                                "card_cvv" => "080" })
        end
        before do
          card = credit_card_example
          allow(PagarMe::Card).to receive(:find).with(card_id).and_return(card)
        end
        let(:card_response) do
          MeSalva::Payment::Pagarme::Card.new.show(card_id)
        end
        it 'returns one user credit card' do
          get :show, params: { id: card_id }

          assert_apiv2_response(:ok, credit_card_example, default_serializer)
        end
      end
      context 'for an invalid credit card' do
        let(:card_id) { 'card_2' }
        before do
          card = nil
          allow(PagarMe::Card).to receive(:find).with(card_id).and_return(card)
        end
        let(:card_response) do
          MeSalva::Payment::Pagarme::Card.new.show(card_id)
        end
        it 'returns not found' do
          get :show, params: { id: card_id }

          expect(response).to have_http_status(:not_found)
          expect(parsed_response['errors'].first).to eq("não encontrado")
        end
      end
      context 'for an empty credit card information' do
        let(:card_id) { '' }
        before do
          card = nil
          allow(PagarMe::Card).to receive(:find).with(card_id).and_return(card)
        end
        let(:card_response) do
          MeSalva::Payment::Pagarme::Card.new.show(card_id)
        end
        it 'returns bad request' do
          get :show, params: { id: card_id }

          expect(response).to have_http_status(:bad_request)
          expect(parsed_response['errors'].first).to eq("requisição incorreta")
        end
      end
    end
  end

  context '#create' do
    context 'as user' do
      before { user_session }
      context 'with a valid customer' do
        before { user.update(pagarme_customer_id: 1) }
        let(:customer_id) { user.pagarme_customer_id }
        context 'for a valid credit card information' do
          let(:credit_card_example) do
            { "card_number" => "4111111111111111",
              "card_holder_name" => "Customer Name Example",
              "card_expiration_date" => "0919",
              "card_cvv" => "080" }
          end
          before do
            card = double
            allow(PagarMe::Card).to receive(:new).with(credit_card_example \
              .merge("customer_id" => customer_id)).and_return(card)
            allow(card).to receive(:create).and_return(card)
            allow(card).to receive(:id).and_return('card_cjuwydymb04mt9x6e5xr30pmk')
            allow(card).to receive(:valid).and_return(true)
          end
          let(:card_response) do
            MeSalva::Payment::Pagarme::Card.new.create(credit_card_example \
              .merge("customer_id" => customer_id))
          end
          it 'creates a credit card on pagarme and returns true for the credit card ' \
             'validation information' do
            post :create, params: credit_card_example

            assert_apiv2_response(:created, card_response, V2::UserCreditCardCreateSerializer)
          end
        end
        context 'for an invalid credit card information' do
          let(:credit_card_example) do
            { "card_number" => "123456",
              "card_holder_name" => "Customer Name Example",
              "card_expiration_date" => "0900",
              "card_cvv" => "080" }
          end
          before do
            card = double
            allow(PagarMe::Card).to receive(:new).with(credit_card_example \
              .merge("customer_id" => customer_id)).and_return(card)
            allow(card).to receive(:create).and_return(card)
            allow(card).to receive(:id).and_return(nil)
            allow(card).to receive(:valid).and_return(false)
          end
          let(:card_response) do
            MeSalva::Payment::Pagarme::Card.new.create(credit_card_example)
          end
          it 'do not create any credit card on pagarme and returns false for the credit card ' \
             'validation information as an unprocessable entity' do
            post :create, params: credit_card_example

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
        context 'for an empty credit card information' do
          let(:credit_card_example) { {} }
          before do
            allow(PagarMe::Card).to receive(:new).with(credit_card_example).and_return(nil)
          end
          let(:card_response) do
            MeSalva::Payment::Pagarme::Card.new.create(credit_card_example)
          end
          it 'do not create any credit card on pagarme and returns a bad request as response' do
            post :create, params: credit_card_example

            expect(response).to have_http_status(:bad_request)
          end
        end
      end
    end
  end
end
