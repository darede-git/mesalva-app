# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostbacksController, type: :controller do
  include PostbackHelper

  let(:order) { create(:order_valid, price_paid: 10) }
  let!(:valid_pagarme_postback) do
    JSON.parse(File.read('spec/fixtures/pagarme_postback.json'))
  end
  let(:pagarme_transaction) do
    FactoryBot.attributes_for(:pagarme_transaction)
  end

  let(:pagarme_subscription) do
    FactoryBot.attributes_for(:pagarme_subscription)
  end

  let(:revenuecat_webhook_auth_header) do
    add_custom_headers('HTTP_AUTHORIZATION' => ENV['REVENUE_CAT_WEBHOOK_AUTH'])
  end

  before :each do
    allow(MeSalva::Payment::Pagarme::Postback)
      .to receive(:valid_signature?)
      .and_return(true)
  end

  describe 'POST #create' do
    context 'as a valid request' do
      context 'order by one payment method' do
        context 'order by card' do
          let!(:card1) do
            create(:payment, :card,
                   order: order,
                   pagarme_transaction_attributes: pagarme_transaction)
          end
          context 'status change from pending to paid' do
            before { status_from_to('processing', 'paid') }

            context 'should transit order to paid and payment to captured' do
              it_behaves_like 'a transit order' do
                let(:payment_status) { 'captured' }
              end
            end
          end

          context 'status change from paid to refunded' do
            before do
              status_from_to('captured', 'refunded')
              card1.state_machine.transition_to(:captured)
            end

            context 'should transit order to refunded' do
              # it_behaves_like 'a transit order' do
              #   skip "breaks for some reason"
              #   let(:payment_status) { 'refunded' }
              # end
            end
          end

          context 'double request' do
            context 'status change from refunded to refunded' do
              before do
                status_from_to('paid', 'refunded')
                card1.state_machine.transition_to(:captured)
                card1.state_machine.transition_to(:refunded)
              end
              it 'should returns http status not modified' do
                post :create, params: valid_pagarme_postback

                assert_type_and_status(:ok)
              end
            end
          end

          context 'status change from pending to refunded' do
            before { status_from_to('processing', 'refunded') }

            it 'should returns http status method not allowed' do
              post :create, params: valid_pagarme_postback

              assert_type_and_status(:method_not_allowed)
            end
          end

          context 'status change from pending to failed' do
            before { status_from_to('processing', 'refused') }

            it 'should transit order to failed' do
              expect(UpdateIntercomUserWorker).to receive(:perform_async)
              post :create, params: valid_pagarme_postback

              expect(response).to have_http_status(:no_content)
              expect(response.content_type).to eq(nil)
              assert_payment_status(card1, 'failed')
              assert_order_status(order, 3)
              expect(card1.reload.error_message)
                .to eq('Saldo do cartão insuficiente. '\
                       'Dúvidas? Fale com a gente!')
            end
          end

          context 'reprocessed with no anti fraud request' do
            it 'sets the original order payment as reprocessed' do
              valid_original_transaction_id(card1.transaction_id)

              post :create, params: valid_pagarme_postback
              expect(card1.reload.reprocessed).to eq(true)
            end
          end
        end

        context 'order by bank slip' do
          let!(:bank_slip) do
            create(:payment, :bank_slip,
                   order: order,
                   pagarme_transaction_attributes: pagarme_transaction)
          end
          context 'status change from pending to paid' do
            before { status_from_to('waiting_payment', 'paid') }
            it 'should transit order and payment to paid' do
              expect(CreateIntercomEventWorker).to receive(:perform_async).twice

              post :create, params: valid_pagarme_postback

              expect(response).to have_http_status(:no_content)
              expect(response.content_type).to eq(nil)
              assert_payment_status(bank_slip, 'paid')
              assert_order_status(order, 2)
            end
          end
        end
      end

      context 'as a subscription renew' do
        let!(:subscription) do
          FactoryBot
            .create(:subscription,
                    orders: [order],
                    pagarme_subscription_attributes: pagarme_subscription)
        end
        context 'new postback with paid status' do
          let!(:card) do
            create(:payment, :card,
                   order: order,
                   pagarme_transaction_attributes: { transaction_id: 9876 })
          end
          before { order.reload }
          it 'should creates a new order and update current subscription' do
            assert_subscription_postback('paid', 1, 1, 1)
          end
        end

        context 'new postback with pending payment' do
          let!(:card) do
            create(:payment, :card,
                   order: order,
                   pagarme_transaction_attributes: { transaction_id: 9876 })
          end
          before { order.reload }
          it 'should update subscription status and transit payment to fail' do
            assert_subscription_postback('pending_payment', 1, 1, 0)

            expect(subscription.reload.active).to eq(true)
            expect(subscription.orders.last.status).to eq(3)
          end
        end

        context 'new postback with canceled status' do
          let!(:card) do
            create(:payment, :card,
                   order: order,
                   pagarme_transaction_attributes: pagarme_transaction)
          end
          before { order.reload }
          it 'should deactive subscription' do
            assert_subscription_postback('canceled', 0, 0, 0)

            expect(subscription.reload.active).to eq(false)
            expect(subscription.reload.status).to eq('canceled')
          end
        end

        context 'new postback with unpaid payment' do
          let!(:card) do
            create(:payment, :card,
                   order: order,
                   pagarme_transaction_attributes: pagarme_transaction)
          end
          before { order.reload }
          it 'should cancel subscription and transit payment to fail' do
            assert_subscription_postback('unpaid', 0, 0, 0)

            expect(subscription.reload.active).to eq(false)
            expect(subscription.reload.status).to eq('unpaid')
            expect(card.reload.status).to eq('failed')
            expect(subscription.orders.last.status).to eq(3)
          end
        end

        context 'new postback with bank_slip as payment_method' do
          let!(:bank_slip) do
            create(:payment, :bank_slip,
                   order: order,
                   pagarme_transaction_attributes: { transaction_id: 9876 })
          end
          it 'creates a new order with bank_slip payment' do
            assert_subscription_postback('paid', 1, 1, 1, 'boleto')
            expect(subscription.reload.orders.last.checkout_method)
              .to eq('bank_slip')
          end
        end
      end
    end
  end

  before { revenuecat_webhook_auth_header }
  describe 'POST #revenuecat' do
    let!(:package) { create(:package_valid_with_price) }
    let!(:user2) { create(:user) }
    let!(:admin) { create(:admin) }
    context 'through RevenueCat Webhook' do
      context 'for an initial purchase event' do
        context ' with valid play store metadata' do
          let!(:id) { 1 }
          let!(:store) { "PLAY_STORE" }
          let!(:purchase_index) { 0 }
          let!(:original_transaction_id) { "GPA.3345-7300-5002-12345" }
          let!(:transaction_id) { "GPA.3345-7300-5002-12345" }
          let!(:type) { "INITIAL_PURCHASE" }
          let!(:payment) { create(:payment, :with_play_store_transaction) }
          let(:valid_params) do
            { event: revenuecat_postback(id, store, transaction_id, type,
                                         original_transaction_id) }
          end
          it 'update a play store transaction and returns the event informations' do
            play_store_transaction = PlayStoreTransaction.take
            post :revenuecat, params: valid_params
            new_metadata = play_store_transaction.reload.metadata
            expect(response).to have_http_status(:ok)
            new_metadata_expects(transaction_id: transaction_id, metadata: new_metadata,
                                 original_transaction_id: original_transaction_id,
                                 purchase_index: purchase_index, store: store,
                                 postback_info: valid_params[:event], type: type)
          end
        end

        context 'with valid app store metadata' do
          let!(:id) { 1 }
          let!(:store) { "APP_STORE" }
          let!(:purchase_index) { 0 }
          let!(:original_transaction_id) { "001122334455667" }
          let!(:transaction_id) { "001122334455667" }
          let!(:type) { "INITIAL_PURCHASE" }
          let!(:payment) { create(:payment, :with_app_store_transaction) }
          let(:valid_params) do
            { event: revenuecat_postback(id, store, transaction_id, type,
                                         original_transaction_id) }
          end
          it 'update an app store transaction and returns the event informations' do
            app_store_transaction = AppStoreTransaction.take
            post :revenuecat, params: valid_params
            new_metadata = app_store_transaction.reload.metadata
            expect(response).to have_http_status(:ok)
            expect(app_store_transaction.reload['transaction_id']).to eq(transaction_id)
            new_metadata_expects(transaction_id: transaction_id, metadata: new_metadata,
                                 original_transaction_id: original_transaction_id,
                                 purchase_index: purchase_index, store: store,
                                 postback_info: valid_params[:event], type: type)
          end
        end
      end

      context 'for a renewal event' do
        let!(:type) { "RENEWAL" }
        context 'with valid play store metadata' do
          let!(:store) { "PLAY_STORE" }
          let!(:original_transaction_id) { "GPA.3345-7300-5002-12345" }
          context 'with an existent subscription with the original transaction and no renewals' do
            let!(:renew_transaction_id) { "GPA.3345-7300-5002-12345..0" }
            let!(:purchase_index) { 1 }
            let(:counts_expected) { { transaction: 2, order: 2, order_payment: 2, access: 1 } }
            let(:valid_params) do
              { event: revenuecat_postback(id,
                                           store,
                                           renew_transaction_id,
                                           type,
                                           original_transaction_id) }
            end
            context 'with an already updated transaction_id' do
              let!(:id) { 1 }
              let!(:play_store_order) do
                create(:in_app_order_with_original_play_store_transaction_with_new_id,
                       :expired,
                       broker: 'play_store')
              end
              it 'should create an access for 30 days, a new order and new order payment, whitout' \
                 'updating the transaction_id' do
                post :revenuecat, params: valid_params
                new_metadata = PlayStoreTransaction.last.metadata
                expect(response).to have_http_status(:ok)
                new_metadata_expects(transaction_id: renew_transaction_id, metadata: new_metadata,
                                     original_transaction_id: original_transaction_id,
                                     purchase_index: purchase_index, store: store,
                                     postback_info: valid_params[:event], type: type)
                subscription_renew_expects(original_transaction_id, renew_transaction_id,
                                           counts_expected, PlayStoreTransaction)
              end
            end

            context 'with an old transaction_id' do
              let!(:id) { 2 }
              let!(:transaction_id_seq) { 2 }
              let!(:renew_transaction_id) { "GPA.3345-7300-5002-12345..0" }
              let!(:play_store_order) do
                create(:in_app_order_with_original_play_store_transaction_with_old_id,
                       :expired,
                       broker: 'play_store')
              end
              it 'should create an access for 30 days, a new order and new order payment, ' \
                 'updating the transaction_id' do
                post :revenuecat, params: valid_params
                first_metadata = PlayStoreTransaction.first.metadata
                new_metadata = PlayStoreTransaction.last.metadata
                expect(response).to have_http_status(:ok)
                first_metadata_expects(first_metadata, original_transaction_id, store,
                                       transaction_id_seq)
                new_metadata_expects(transaction_id: renew_transaction_id, metadata: new_metadata,
                                     original_transaction_id: original_transaction_id,
                                     purchase_index: purchase_index, store: store,
                                     postback_info: valid_params[:event], type: type)
                subscription_renew_expects(original_transaction_id, renew_transaction_id,
                                           counts_expected, PlayStoreTransaction)
              end
            end
          end

          context 'with an existent subscription with the original transaction and one renewal' do
            let!(:renew_transaction_id) { "GPA.3345-7300-5002-12345..1" }
            let!(:purchase_index) { 2 }
            let(:counts_expected) { { transaction: 3, order: 4, order_payment: 3, access: 2 } }
            let(:valid_params) do
              { event: revenuecat_postback(id, store, renew_transaction_id, type,
                                           original_transaction_id) }
            end
            context 'with an already updated transaction_id' do
              let!(:id) { 3 }
              let!(:play_store_order_original) do
                create(:in_app_order_with_original_play_store_transaction_with_new_id,
                       :expired,
                       broker: 'play_store')
              end
              let!(:play_store_order_renewal_1) do
                create(:in_app_order_with_renewal_1_play_store_transaction,
                       :expired,
                       broker: 'play_store')
              end
              it 'should create an access for 30 days, a new order and new order payment, whitout' \
                 'updating the transaction_id' do
                transit_transaction(PlayStoreTransaction)
                post :revenuecat, params: valid_params
                new_metadata = PlayStoreTransaction.last.metadata
                expect(response).to have_http_status(:ok)
                new_metadata_expects(transaction_id: renew_transaction_id, metadata: new_metadata,
                                     original_transaction_id: original_transaction_id,
                                     purchase_index: purchase_index, store: store,
                                     postback_info: valid_params[:event], type: type)
                subscription_renew_expects(original_transaction_id, renew_transaction_id,
                                           counts_expected, PlayStoreTransaction)
              end
            end

            context 'with an old transaction_id' do
              let!(:id) { 4 }
              let!(:transaction_id_seq) { 3 }
              let!(:play_store_order_original) do
                create(:in_app_order_with_original_play_store_transaction_with_old_id,
                       :expired,
                       broker: 'play_store')
              end
              let!(:play_store_order_renewal_2) do
                create(:in_app_order_with_renewal_2_play_store_transaction,
                       :expired,
                       broker: 'play_store')
              end
              it 'should create an access for 30 days, a new order and new order payment, ' \
                 'updating the transaction_id' do
                transit_transaction(PlayStoreTransaction)
                post :revenuecat, params: valid_params
                first_metadata = PlayStoreTransaction.first.metadata
                new_metadata = PlayStoreTransaction.last.metadata
                expect(response).to have_http_status(:ok)
                first_metadata_expects(first_metadata, original_transaction_id, store,
                                       transaction_id_seq)
                new_metadata_expects(transaction_id: renew_transaction_id, metadata: new_metadata,
                                     original_transaction_id: original_transaction_id,
                                     purchase_index: purchase_index, store: store,
                                     postback_info: valid_params[:event], type: type)
                subscription_renew_expects(original_transaction_id, renew_transaction_id,
                                           counts_expected, PlayStoreTransaction)
              end
            end
          end
          context 'without previous transaction or existent subscription' do
            let!(:id) { 5 }
            let!(:type) { "RENEWAL" }
            let!(:store) { "PLAY_STORE" }
            let!(:original_transaction_id) { "GPA.3345-7300-5002-12345" }
            let!(:renew_transaction_id) { "GPA.3345-7300-5002-12345..0" }
            let(:valid_params) do
              { event: revenuecat_postback(id, store, renew_transaction_id, type,
                                           original_transaction_id) }
            end
            it 'should not create anything and render ok' do
              post :revenuecat, params: valid_params
              expect(response).to have_http_status(:unprocessable_entity)
              expect(PlayStoreTransaction.all.count).to eq(0)
              expect(Order.all.count).to eq(0)
              expect(OrderPayment.all.count).to eq(0)
              expect(Access.all.count).to eq(0)
            end
          end
        end

        context 'with valid app store metadata' do
          let!(:store) { "APP_STORE" }
          let!(:original_transaction_id) { "001122334455667" }
          let!(:type) { "RENEWAL" }
          context 'with an existent subscription with the original transaction and no renewals' do
            let(:counts_expected) { { transaction: 2, order: 2, order_payment: 2, access: 1 } }
            let!(:renew_transaction_id) { "001122334455667..1" }
            let!(:revenuecat_transaction_id) { "112233445566778" }
            let!(:purchase_index) { 1 }
            let(:valid_params) do
              { event: revenuecat_postback(id, store, revenuecat_transaction_id, type,
                                           original_transaction_id) }
            end
            context 'with an already updated transaction_id' do
              let!(:id) { 1 }
              let!(:app_store_order) do
                create(:in_app_order_with_original_app_store_transaction_with_new_id,
                       :expired,
                       broker: 'app_store')
              end
              it 'should create an access for 30 days, a new order and new order payment, whitout' \
                 'updating the transaction_id' do
                post :revenuecat, params: valid_params
                new_metadata = AppStoreTransaction.last.metadata
                expect(response).to have_http_status(:ok)
                new_metadata_expects(transaction_id: renew_transaction_id, metadata: new_metadata,
                                     original_transaction_id: original_transaction_id,
                                     purchase_index: purchase_index, store: store,
                                     postback_info: valid_params[:event], type: type)
                subscription_renew_expects(original_transaction_id, renew_transaction_id,
                                           counts_expected, AppStoreTransaction)
              end
            end

            context 'with an old transaction_id' do
              let!(:id) { 2 }
              let!(:transaction_id_seq) { 2 }
              let!(:app_store_order) do
                create(:in_app_order_with_original_app_store_transaction_with_old_id,
                       :expired,
                       broker: 'app_store')
              end
              it 'should create an access for 30 days, a new order and new order payment, ' \
                 'updating the transaction_id' do
                post :revenuecat, params: valid_params
                first_metadata = AppStoreTransaction.first.metadata
                new_metadata = AppStoreTransaction.last.metadata
                expect(response).to have_http_status(:ok)
                first_metadata_expects(first_metadata, original_transaction_id, store,
                                       transaction_id_seq)
                new_metadata_expects(transaction_id: renew_transaction_id, metadata: new_metadata,
                                     original_transaction_id: original_transaction_id,
                                     purchase_index: purchase_index, store: store,
                                     postback_info: valid_params[:event], type: type)
                subscription_renew_expects(original_transaction_id, renew_transaction_id,
                                           counts_expected, AppStoreTransaction)
              end
            end
          end

          context 'with an existent subscription with the original transaction and one renewal' do
            let(:counts_expected) { { transaction: 3, order: 4, order_payment: 3, access: 2 } }
            let!(:renew_transaction_id) { "001122334455667..2" }
            let!(:revenuecat_transaction_id) { "223344556677889" }
            let!(:purchase_index) { 2 }
            let(:valid_params) do
              { event: revenuecat_postback(id, store, revenuecat_transaction_id, type,
                                           original_transaction_id) }
            end
            context 'with an already updated transaction_id' do
              let!(:id) { 3 }
              let!(:app_store_order_original) do
                create(:in_app_order_with_original_app_store_transaction_with_new_id,
                       :expired,
                       broker: 'app_store')
              end
              let!(:app_store_order_renewal_1) do
                create(:in_app_order_with_renewal_1_app_store_transaction,
                       :expired,
                       broker: 'app_store')
              end
              it 'should create an access for 30 days, a new order and new order payment, whitout' \
                 'updating the transaction_id' do
                transit_transaction(AppStoreTransaction)
                post :revenuecat, params: valid_params
                new_metadata = AppStoreTransaction.last.metadata
                expect(response).to have_http_status(:ok)
                new_metadata_expects(transaction_id: renew_transaction_id, metadata: new_metadata,
                                     original_transaction_id: original_transaction_id,
                                     purchase_index: purchase_index, store: store,
                                     postback_info: valid_params[:event], type: type)
                subscription_renew_expects(original_transaction_id, renew_transaction_id,
                                           counts_expected, AppStoreTransaction)
              end
            end

            context 'with an old transaction_id' do
              let!(:id) { 4 }
              let!(:transaction_id_seq) { 3 }
              let!(:app_store_order_original) do
                create(:in_app_order_with_original_app_store_transaction_with_old_id,
                       :expired,
                       broker: 'app_store')
              end
              let!(:app_store_order_renewal_2) do
                create(:in_app_order_with_renewal_2_app_store_transaction,
                       :expired,
                       broker: 'app_store')
              end
              it 'should create an access for 30 days, a new order and new order payment, ' \
                 'updating the transaction_id' do
                transit_transaction(AppStoreTransaction)
                post :revenuecat, params: valid_params
                first_metadata = AppStoreTransaction.first.metadata
                new_metadata = AppStoreTransaction.last.metadata
                expect(response).to have_http_status(:ok)
                first_metadata_expects(first_metadata, original_transaction_id, store,
                                       transaction_id_seq)
                new_metadata_expects(transaction_id: renew_transaction_id, metadata: new_metadata,
                                     original_transaction_id: original_transaction_id,
                                     purchase_index: purchase_index, store: store,
                                     postback_info: valid_params[:event], type: type)
                subscription_renew_expects(original_transaction_id, renew_transaction_id,
                                           counts_expected, AppStoreTransaction)
              end
            end
          end
          context 'without previous transaction or existent subscription' do
            let!(:id) { 5 }
            let!(:type) { "RENEWAL" }
            let!(:store) { "APP_STORE" }
            let!(:original_transaction_id) { "001122334455667" }
            let!(:renew_transaction_id) { "112233445566778" }
            let(:valid_params) do
              { event: revenuecat_postback(id, store, renew_transaction_id, type,
                                           original_transaction_id) }
            end
            it 'should not create anything and render ok' do
              post :revenuecat, params: valid_params
              expect(response).to have_http_status(:unprocessable_entity)
              expect(AppStoreTransaction.all.count).to eq(0)
              expect(Order.all.count).to eq(0)
              expect(OrderPayment.all.count).to eq(0)
              expect(Access.all.count).to eq(0)
            end
          end
        end
      end

      context 'for an event different than initial purchase and renewal' do
        context 'with valid play store metadata' do
          let!(:id) { 1 }
          let!(:store) { "PLAY_STORE" }
          let!(:transaction_id) { "GPA.3345-7300-5002-12345" }
          let!(:type) { "CANCELATION" }
          let!(:payment) { create(:payment, :with_play_store_transaction) }
          let(:valid_params) { { event: revenuecat_postback(id, store, transaction_id, type) } }
          it 'do not update a play store transaction and render ok' do
            post :revenuecat, params: valid_params
            expect(response).to have_http_status(:ok)
          end
        end

        context 'with valid play store metadata' do
          let!(:id) { 1 }
          let!(:store) { "APP_STORE" }
          let!(:transaction_id) { "001122334455667" }
          let!(:type) { "CANCELATION" }
          let!(:payment) { create(:payment, :with_app_store_transaction) }
          let(:valid_params) { { event: revenuecat_postback(id, store, transaction_id, type) } }
          it 'do not update an app store transaction and render ok' do
            post :revenuecat, params: valid_params
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context 'with invalid transaction_id' do
        let!(:payment) { create(:payment, :with_app_store_transaction) }
        let(:valid_params) { { event: revenuecat_postback_missing_info("APP_STORE") } }
        it 'returns a bad request' do
          post :revenuecat, params: valid_params
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with invalid metadata' do
        let(:invalid_params) { { event: {} } }
        it 'returns a bad request' do
          post :revenuecat, params: invalid_params
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with invalid store' do
        let(:invalid_params) do
          { event: revenuecat_postback(2, 'ANOTHER_STORE', "9999999999", "INITIAL_PURCHASE") }
        end
        it 'returns a bad request' do
          post :revenuecat, params: invalid_params
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'POST #rdstation' do
    context 'through rdstation conversion webhook' do
      let(:lead) do
        { id: "390319847", email: "teste@webhook.com",
          name: "Fulano Suporte RD", company: nil,
          job_title: "Analista", bio: nil,
          public_url: "http://rdstation.com.br/leads/public/807029c7-267f-4225-8428-87ae2dab34c3",
          created_at: "2018-09-26T17:57:10.189-03:00",
          opportunity: "true", number_conversions: "1" }
      end
      it 'should receive right content' do
        expect do
          post :rdstation, params: { trigger: 'conversion', leads: [lead] }

          assert_type_and_status(:ok)
        end.to change(RdstationLog, :count).by(1)
      end
    end
  end

  def assert_subscription_postback(to_status, order_count, payment_count,
                                   access_count, payment_method = 'credit_card')
    expect do
      post :create, params: subscription_postback(to_status, payment_method)
    end.to change(Order, :count)
      .by(order_count).and change(OrderPayment, :count)
      .by(payment_count).and change(Access, :count).by(access_count)

    assert_status(:no_content)
  end

  def assert_status(status)
    expect(response).to have_http_status(status)
  end

  def status_from_to(old, current)
    valid_pagarme_postback['old_status'] = old
    valid_pagarme_postback['current_status'] = current
  end

  def valid_original_transaction_id(transaction_id)
    valid_pagarme_postback['transaction']['metadata'] = {}
    valid_pagarme_postback['transaction']['metadata']['pagarme_original_transaction_id'] =
      transaction_id
  end

  def assert_payment_status(payment, status)
    expect(payment.reload.state_machine.current_state).to eq(status)
  end

  def assert_order_status(order, status)
    expect(order.reload.status).to eq(status)
  end
end
