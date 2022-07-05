# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefundsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:admin) { create(:admin) }

  describe 'PUT #update' do
    context 'with admin session' do
      before { authentication_headers_for(admin) }
      context 'as pagarme' do
        let!(:order) { create(:order_valid) }
        context 'with valid attributes' do
          before do
            order.update(broker: 'pagarme')
            VCR.use_cassette("RefundsController before") do
              payment = create(:payment,
                               :card,
                               order: order,
                               card_token:
                               'card_ckljewknk0iyn0i9t63o9h49m')

              charging = MeSalva::Payment::Pagarme::Charge
                         .new(payment, 'custom billing name').perform
              payment.update(
                pagarme_transaction_attributes: { transaction_id: charging.id,
                                                  order_payment: payment }
              )
              order.state_machine.transition_to(:paid)
            end
          end

          it_behaves_like 'returns http ok'
        end

        context 'with invalid order id' do
          it 'returns http not found' do
            put :update, params: { order_id: 'token' }

            assert_type_and_status(:not_found)
          end
        end
      end

      context 'as play_store' do
        let!(:order) { create(:in_app_order) }
        before do
          order.state_machine.transition_to(:paid)
          allow_any_instance_of(MeSalva::Payment::PlayStore::Client)
            .to receive(:set_new_access_token).and_return(true)
        end

        context 'refund occurs correctly' do
          before do
            allow_any_instance_of(MeSalva::Payment::PlayStore::Client)
              .to receive(:refund).and_return(true)
          end
          it 'returns http status ok' do |example|
            VCR.use_cassette(test_name(example)) do
              put :update, params: { order_id: order.token }

              assert_type_and_status(:ok)
              expect(order.reload.status).to eq(6)
            end
          end
        end

        context 'refund does not occur correctly' do
          before do
            allow_any_instance_of(MeSalva::Payment::PlayStore::Client)
              .to receive(:refund).and_return(false)
          end
          it 'returns http status unprocessable_entity' do |example|
            VCR.use_cassette(test_name(example)) do
              put :update, params: { order_id: order.token }

              assert_type_and_status(:unprocessable_entity)
              expect(order.reload.status).to eq(2)
            end
          end
        end
      end

      context 'as iugu' do # TODO: TO BE REMOVED
        let!(:order) { create(:order_valid, broker: 'iugu') }
        context 'with valid attributes' do
          before do
            stub_const('MeSalva::Payment::Iugu::Invoice', double)
            allow(MeSalva::Payment::Iugu::Invoice).to receive(:new)
              .and_return(MeSalva::Payment::Iugu::Invoice)
            allow(MeSalva::Payment::Iugu::Invoice).to receive(:refund)
              .and_return(true)

            order.state_machine.transition_to(:paid)
          end

          it_behaves_like 'returns http ok'
        end

        context 'with invalid order id' do
          it 'returns http not found' do
            put :update, params: { order_id: 'token' }

            assert_type_and_status(:not_found)
          end
        end
      end
    end

    context 'as user' do
      it 'returns http unauthorized' do
        authentication_headers_for(user)
        put :update, params: { order_id: 'token' }

        assert_type_and_status(:unauthorized)
      end
    end
  end
end
