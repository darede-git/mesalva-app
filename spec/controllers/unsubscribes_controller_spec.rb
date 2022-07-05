# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnsubscribesController, type: :controller do
  include UserAccessSpecHelper

  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:order) { create(:order_with_pagarme_subscription, user_id: user.id) }
  let!(:subscription) do
    create(:subscription, user_id: user.id, orders: [order])
  end
  let(:card) do
    create(:payment, :card,
           order: order,
           card_token: 'card_ckljewknk0iyn0i9t63o9h49m')
  end

  describe 'PUT #update' do
    context 'with user session' do
      context 'testing with pagarme integration' do
        before do
          VCR.use_cassette("UnsubscribesController before") do
            charging = perform_pagarme_card_charge
            update_order_expires_at(charging.current_period_end)
            activate_subscription(charging.id, subscription)
          end
        end

        context 'with valid order context' do
          let(:checkout_client_event_name) { 'checkout_ex_client' }
          let(:checkout_client_event_attributes) do
            { cf_package_name: order.package.name,
              cf_package_slug: order.package.slug,
              cf_package_duration: order.package.duration.to_s,
              cf_package_sku: order.package.sku }
          end
          before do
            expect_rd_station_event(checkout_client_event_name,
                                    order.package.sku,
                                    checkout_client_event_attributes)
          end
          before do
            card.state_machine.transition_to(:captured)
            authentication_headers_for(user)
            expect(UpdateIntercomUserWorker).to receive(:perform_async)
            expect(CrmRdstationUnsubscriberEventWorker)
              .to receive(:perform_async).with(subscription.id)
            Access.first.update(starts_at: Date.yesterday)
          end

          context 'perform unsubscribes action' do
            it 'returns http ok' do |example|
              VCR.use_cassette(test_name(example)) do
                put :update, params: { subscription_id: subscription.token }

                assert_type_and_status(:ok)
                expect(parsed_response['data']['attributes']['active'])
                  .to be_falsey
                user_state_transition_asserts(user.reload, :ex_subscriber)
              end
            end
          end
        end

        context 'with invalid attributes' do
          before { authentication_headers_for(user2) }
          it 'returns http not found' do
            put :update, params: { subscription_id: subscription.id }

            assert_type_and_status(:not_found)
          end
        end
      end
    end
  end

  def expect_rd_station_event(event_name, client_type, attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: "#{event_name}|#{client_type}",
              payload: attributes })
      .and_return(client)
    expect(client).to receive(:create)
  end

  def activate_subscription(charging_id, subscription)
    subscription.update(
      active: true, status: 'paid',
      pagarme_subscription_attributes: { pagarme_id: charging_id,
                                         subscription: subscription }
    )
  end

  def perform_pagarme_card_charge
    MeSalva::Payment::Pagarme::Charge.new(card, 'custom billing name').perform
  end

  def update_order_expires_at(expires_at)
    order.update(expires_at: expires_at)
  end
end
