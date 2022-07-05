# frozen_string_literal: true

require 'me_salva/payment/play_store/subscription'
require 'me_salva/payment/play_store/invoice'
require 'spec_helper'

describe MeSalva::Payment::PlayStore::Subscription do
  subject { described_class }

  let(:access_code_response) do
    JSON.parse(File.read('spec/fixtures/google/access_token.json'))
  end
  let(:access_token_sucess_response) do
    double(code: 200, parsed_response: access_code_response)
  end
  let(:order_info_response) do
    JSON.parse(File.read('spec/fixtures/google/order_data.json'))
  end
  let(:invalid_order_response) do
    JSON.parse(File.read('spec/fixtures/google/invalid_order_data.json'))
  end
  let(:pending_order_response) do
    JSON.parse(File.read('spec/fixtures/google/pending_order_data.json'))
  end
  let(:order_invoice) do
    MeSalva::Payment::PlayStore::Invoice.new(order_info_response)
  end
  let(:invalid_order_invoice) do
    MeSalva::Payment::PlayStore::Invoice.new(invalid_order_response)
  end
  let(:pending_order_invoice) do
    MeSalva::Payment::PlayStore::Invoice.new(pending_order_response)
  end
  let(:canceled_subscription) do
    MeSalva::Payment::PlayStore::Invoice.new(
      order_info_response.merge('autoRenewing' => 'false')
    )
  end

  before do
    allow(HTTParty).to receive(:post).and_return(access_token_sucess_response)
    allow_any_instance_of(MeSalva::Payment::PlayStore::Client)
      .to receive(:subscription_last_invoice_from).and_return(order_invoice)
  end

  describe '#process' do
    let!(:last_order) do
      create(:in_app_order)
    end
    let(:paid_recurrency_broker_data) do
      last_order.broker_data.merge(order_info_response)
    end
    let(:invalid_recurrency_broker_data) do
      last_order.broker_data.merge(invalid_order_response)
    end

    context 'there are no new orders' do
      context 'subscription will not be renewed' do
        before do
          allow_any_instance_of(MeSalva::Payment::PlayStore::Client)
            .to receive(:subscription_last_invoice_from)
            .and_return(canceled_subscription)
        end
        it 'updates order to processed = true' do
          last_order.update(broker_invoice: order_info_response['orderId'])
          expect do
            subject.new.process(last_order)
          end.to change(::Order, :count).by(0)
          expect(last_order.processed).to be_truthy
        end
      end
      context 'subscription will be renewed' do
        it 'last order will not be marked as processed' do
          last_order.update(broker_invoice: order_info_response['orderId'])
          expect do
            subject.new.process(last_order)
          end.to change(::Order, :count).by(0)
          expect(last_order.processed).to be_falsey
        end
      end
    end
    context 'there is a new order' do
      context 'new order status is paid' do
        it 'creates a new order with status paid and processed = false' do
          assert_order_creation(1)

          new_order = Order.find_by_broker_invoice(
            order_info_response['orderId']
          )
          expect(new_order).not_to be_nil
          expect(new_order.status).to eq(2)
          expect(new_order.expires_at)
            .to eq(Time.at(order_info_response['expiryTimeMillis'].to_i / 1000))
          expect(new_order.broker_data).to eq(paid_recurrency_broker_data)
          expect(new_order.processed).to be_falsey
          expect(last_order.processed).to be_truthy
        end
      end

      context 'new order status is invalid' do
        before do
          allow_any_instance_of(MeSalva::Payment::PlayStore::Client)
            .to receive(:subscription_last_invoice_from)
            .and_return(invalid_order_invoice)
        end
        it 'creates a new order with invalid status and processed = true' do
          assert_order_creation(0)

          new_order = Order.find_by_broker_invoice(
            order_info_response['orderId']
          )
          expect(new_order).not_to be_nil
          expect(new_order.status).to eq(3)
          expect(new_order.broker_data).to eq(invalid_recurrency_broker_data)
          expect(new_order.processed).to be_truthy
          expect(last_order.processed).to be_truthy
        end
      end

      context 'new order status is pending' do
        before do
          allow_any_instance_of(MeSalva::Payment::PlayStore::Client)
            .to receive(:subscription_last_invoice_from)
            .and_return(pending_order_invoice)
        end
        it 'do not create any orders and do not set last order as precessed' do
          expect do
            subject.new.process(last_order)
          end.to change(::Order, :count).by(0)
          expect(last_order.processed).to be_falsey
        end
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def assert_order_creation(access_change_count)
    expect do
      subject.new.process(last_order)
    end.to change(::Order, :count)
      .by(1).and change(::Access, :count)
      .by(access_change_count).and change(::OrderPayment, :count)
      .by(1).and change(::PlayStoreTransaction, :count)
      .by(1).and change(::Address, :count)
      .by(1)
  end
  # rubocop:enable Metrics/AbcSize
end
