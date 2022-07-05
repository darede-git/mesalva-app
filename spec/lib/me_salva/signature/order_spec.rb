# frozen_string_literal: true

require 'me_salva/signature/order'
require 'spec_helper'
require 'me_salva/crm/users'

describe MeSalva::Signature::Order do
  include CrmEventAssertionHelper

  let(:subscription_response) { 'spec/fixtures/subscription_response.json' }
  let(:invoice_response) { 'spec/fixtures/invoice_response.json' }
  let!(:package_subscription) { create(:package_subscription) }
  let!(:user) { create(:user) }
  let!(:subscription) { create(:subscription, user_id: user.id) }

  describe '.renew' do
    context 'subscription with payment expired process' do
      let!(:order_expired) do
        create(
          :order_expired,
          user_id: user.id,
          package_id: package_subscription.id,
          subscription_id: subscription.id,
          broker_data: JSON.parse(File.read(subscription_response))
        )
      end

      it 'should create a new order' do
        expect(PersistCrmEventWorker).to receive(:perform_async)
        allow(Iugu::Subscription).to receive(:fetch)
          .and_return(Iugu::Subscription
          .new(JSON.parse(File.read(subscription_response))))

        expect { subject.renew(order_expired) }.to change(Order, :count).by(1)

        order_expired.reload
        order = Order.last

        expect(order_expired.processed).to eq(true)
        expect(order.broker_invoice)
          .to eq('D9D0A8F68F7F415A87CDC55EC11A7242')
        expect(order.subscription_id).to eq(subscription.id)
      end
    end
  end

  describe '.update' do
    context 'subscription pending process' do
      let!(:subscription_pending_credit_card) do
        create(
          :pending_order,
          user_id: user.id,
          checkout_method: 'credit_card',
          package_id: package_subscription.id,
          broker_invoice: '1DAA0E24AF87493086AFA06248F81A0C',
          broker_data: JSON.parse(File.read(subscription_response)),
          subscription: create(:subscription)
        )
      end

      let!(:subscription_pending_bank_slip) do
        create(
          :pending_order,
          user_id: user.id,
          package_id: package_subscription.id,
          broker_invoice: '1DAA0E24AF87493086AFA06248F81A0C',
          broker_data: JSON.parse(File.read(subscription_response)),
          subscription: create(:subscription)
        )
      end

      let(:client) { double }
      before do
        Timecop.freeze(Time.now)
        mock_intercom_event
      end

      it 'should update a order status to paid' do
        allow_any_instance_of(MeSalva::Payment::Iugu::Invoice)
          .to receive(:fetch_attributes).and_return(invoice('paid').attributes)

        allow_any_instance_of(MeSalva::Signature::Order)
          .to receive(:expiration_date).and_return(Time.now + 1.month)

        assert_update_subscription(subscription_pending_credit_card, 2)
      end

      it 'should update a order status to expired' do
        assert_checkout_fail('expired', 'checkout_fail',
                             subscription_pending_credit_card, 4)
        expect(subscription_pending_credit_card.subscription.active)
          .to be_falsey
      end

      it 'should update a bank slip order status to expired' do
        assert_checkout_fail('expired', 'boleto_expired',
                             subscription_pending_bank_slip, 4)
        expect(subscription_pending_bank_slip.subscription.active)
          .to be_falsey
      end

      it 'should update a order status to canceled' do
        assert_checkout_fail('canceled', 'checkout_fail',
                             subscription_pending_credit_card, 3)
      end
    end
  end

  def assert_update_subscription(order, order_status)
    subject.update(order)
    assert_order_updated(order.reload, order_status)
  end

  def assert_order_updated(order, order_status)
    expect(order.status).to eq(order_status)
  end

  def assert_checkout_fail(invoice_status, event_name, order, status)
    allow_any_instance_of(MeSalva::Payment::Iugu::Invoice)
      .to receive(:fetch_attributes)
      .and_return(invoice(invoice_status).attributes)

    assert_persist_crm_event(crm_event_params(event_name, user, order: order))
    assert_intercom_event([event_name, user.uid, intercom_params])
    assert_update_subscription(order, status)
  end

  def assert_intercom_event(params)
    expect(CreateIntercomEventWorker).to receive(:perform_async).with(params)
  end

  def assert_persist_crm_event(params)
    expect(PersistCrmEventWorker).to receive(:perform_async).with(params)
  end

  def invoice(status)
    Iugu::Invoice.new(parsed_file(status))
  end

  def parsed_file(status)
    response = JSON.parse(File.read(invoice_response))
    response['status'] = status
    response
  end
end
