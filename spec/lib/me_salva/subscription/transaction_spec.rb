# frozen_string_literal: true

require 'me_salva/subscription/transaction'

describe MeSalva::Subscription::Transaction do
  let(:custom_attributes) do
    { transaction_id: '1234567890' }
  end

  describe '#renew' do
    context 'pagarme transation' do
      let!(:pagarme_transaction) do
        create(:pagarme_transaction)
      end

      it 'returns a new pagarme transaction modifying custom attributes' \
        'and setting order_payment_id as nil' do
        assert_transaction_renewal(PagarmeTransaction, pagarme_transaction)
      end
    end

    context 'play store transaction' do
      let!(:play_store_transaction) do
        create(:play_store_transaction)
      end

      it 'returns a new play store transaction modifying custom' \
        'attributes and setting order_payment_id as nil' do
        assert_transaction_renewal(PlayStoreTransaction, play_store_transaction)
      end
    end

    context 'app store transation' do
      let!(:app_store_transaction) do
        create(:app_store_transaction)
      end

      it 'returns a new app store transaction modifying custom' \
        'attributes and setting order_payment_id as nil' do
        assert_transaction_renewal(AppStoreTransaction, app_store_transaction)
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def assert_transaction_renewal(transaction_class, transaction)
    subject = described_class.new(
      transaction,
      transaction_attributes:
      custom_attributes
    ).renew

    expect(subject.class).to eq(transaction_class)
    expect(subject.metadata).to eq(transaction.metadata)
    expect(subject.transaction_id)
      .to eq(custom_attributes[:transaction_id])
    expect(subject.order_payment_id).to be_nil
  end
  # rubocop:enable Metrics/AbcSize
end
