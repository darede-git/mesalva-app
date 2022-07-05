# frozen_string_literal: true

require 'me_salva/subscription/order'

describe MeSalva::Subscription::Order do
  let(:order_custom_attributes) do
    { broker_invoice: '02056E6E7E3347B499B94F5F775A014F',
      broker: 'pagarme',
      email: 'test@email.com',
      expires_at: Time.now + 1.hour }
  end

  let(:payment_attributes) do
    { payment_method: 'card' }
  end

  let(:transaction_attributes) do
    { transaction_id: 'Transaction test' }
  end

  describe '#renew' do
    context 'pagarme order' do
      let!(:pagarme_order) do
        create(:order_valid, payments: [pagarme_payment])
      end
      let(:pagarme_payment) do
        create(:payment, :with_pagarme_transaction)
      end
      it 'should renew a pagarme order with its payment' do
        assert_order_renewal(pagarme_order, PagarmeTransaction)
      end
    end

    context 'play store order' do
      let!(:play_store_order) do
        create(:in_app_order, payments: [play_store_payment])
      end
      let(:play_store_payment) do
        create(:payment, :with_play_store_transaction)
      end
      it 'should renew a play store order with its payment' do
        assert_order_renewal(play_store_order, PlayStoreTransaction)
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def assert_order_renewal(order, transaction_class)
    expect do
      described_class.new(order,
                          order_attributes: order_custom_attributes,
                          payment_attributes: payment_attributes,
                          transaction_attributes: transaction_attributes)
                     .renew
    end.to change(::Order, :count)
      .by(1).and change(::OrderPayment, :count)
      .by(1).and change(transaction_class, :count).by(1)
    new_order = Order.last

    expect(new_order.payments.count).to eq(1)
    expect(new_order.broker_invoice)
      .to eq(order_custom_attributes[:broker_invoice])
  end
  # rubocop:enable Metrics/AbcSize
end
